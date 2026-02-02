package com.nitssrpi.NIT_SRPI.service;

import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.net.MalformedURLException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@Service
public class FileService {

    // O Path armazena o caminho "raiz" onde todos os arquivos do sistema ficarão
    private final Path rootLocation;

    // O construtor recebe o caminho definido no seu application.yml (file.upload-dir)
    public FileService(@Value("${file.upload-dir}") String uploadDir) {
        this.rootLocation = Paths.get(uploadDir);
    }

    /**
     * O @PostConstruct garante que este método execute ASSIM QUE O SPRING SUBIR.
     * Ele serve para preparar o terreno (criar as pastas) antes de qualquer upload.
     */
    @PostConstruct
    public void init() {
        try {
            // Cria a pasta principal (./uploads), a de assinados e a de templates
            // O 'createDirectories' não dá erro se a pasta já existir.
            Files.createDirectories(rootLocation.resolve("attachments"));
            Files.createDirectories(rootLocation.resolve("templates"));
            System.out.println("SISTEMA DE ARQUIVOS: Pastas verificadas/criadas em: " + rootLocation.toAbsolutePath());
        } catch (IOException e) {
            throw new RuntimeException("ERRO CRÍTICO: Não foi possível criar o diretório de arquivos!", e);
        }
    }

    /**
     * Método para salvar um arquivo que veio do computador/celular do usuário.
     * @param file O arquivo binário vindo do Controller.
     * @return O novo nome único gerado para o arquivo.
     */
    public String store(MultipartFile file) {
        try {
            if (file.isEmpty()) {
                throw new RuntimeException("Falha ao salvar: o arquivo está vazio.");
            }

            // Geramos um nome aleatório (UUID) para evitar que dois usuários
            // mandem arquivos com o mesmo nome e um sobrescreva o outro.
            String fileName = UUID.randomUUID() + "_" + file.getOriginalFilename();

            // Resolvemos o caminho final: ./uploads/attachments/nome_unico.pdf
            Path destinationFile = this.rootLocation.resolve("attachments").resolve(fileName);

            // Copia os bytes do upload para o destino final no disco
            Files.copy(file.getInputStream(), destinationFile, StandardCopyOption.REPLACE_EXISTING);

            return fileName;
        } catch (IOException e) {
            throw new RuntimeException("Erro ao salvar o arquivo no disco.", e);
        }
    }

    /**
     * Método para carregar um arquivo do disco para enviar de volta ao usuário (Download).
     * @param folder A subpasta (templates ou attachments).
     * @param fileName O nome do arquivo que queremos buscar.
     */
    public Resource load(String folder, String fileName) {
        try {
            // Localiza o arquivo na pasta correta
            Path file = rootLocation.resolve(folder).resolve(fileName);
            Resource resource = new UrlResource(file.toUri());

            // Verifica se o arquivo realmente existe e pode ser lido
            if (resource.exists() || resource.isReadable()) {
                return resource;
            } else {
                throw new RuntimeException("Arquivo não encontrado ou sem permissão de leitura: " + fileName);
            }
        } catch (MalformedURLException e) {
            throw new RuntimeException("Erro ao construir o caminho do arquivo.", e);
        }
    }
}