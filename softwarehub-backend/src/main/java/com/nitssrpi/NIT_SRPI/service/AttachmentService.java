package com.nitssrpi.NIT_SRPI.service;

import com.nitssrpi.NIT_SRPI.model.Attachment;
import com.nitssrpi.NIT_SRPI.model.IpTypes;
import com.nitssrpi.NIT_SRPI.repository.AttachmentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
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
import java.util.List;


@Service
@RequiredArgsConstructor
public class AttachmentService {

    private final Path fileStorageLocation;

    @Autowired
    public AttachmentService(@Value("${file.upload-dir}") String uploadDir) {
        // Converte './uploads' em um caminho real no seu PC
        this.fileStorageLocation = Paths.get(uploadDir).toAbsolutePath().normalize();
        System.out.println("📁 Upload dir REAL: " + this.fileStorageLocation);
        try {
            // Cria as pastas caso você mude de PC e elas não existam
            Files.createDirectories(this.fileStorageLocation.resolve("templates"));
            Files.createDirectories(this.fileStorageLocation.resolve("attachments"));
        } catch (Exception ex) {
            throw new RuntimeException("Erro ao criar pastas de upload", ex);
        }
    }


    // Método para Download
    public Resource loadFile(String relativePath) {
        try {
            Path filePath = this.fileStorageLocation.resolve(relativePath).normalize();
            System.out.println("📄 Tentando abrir: " + filePath);
            Resource resource = new UrlResource(filePath.toUri());
            if (resource.exists()) return resource;
            throw new RuntimeException("Arquivo não encontrado: " + relativePath);
        } catch (MalformedURLException ex) {
            throw new RuntimeException("Erro no caminho do arquivo", ex);
        }
    }

    // Método para Upload
    public void saveSignedFile(MultipartFile file, Attachment attachment) {
        try {
            // Nome único: attachments/processo_1_doc_5_assinado.pdf
            String fileName = "attachments/proc_" + attachment.getProcess().getId() + "_att_" + attachment.getId() + ".pdf";
            Path targetLocation = this.fileStorageLocation.resolve(fileName);

            Files.copy(file.getInputStream(), targetLocation, StandardCopyOption.REPLACE_EXISTING);

            attachment.setSignedFilePath(fileName);
            attachment.setStatus("SIGNED");
        } catch (IOException ex) {
            throw new RuntimeException("Erro ao salvar arquivo assinado", ex);
        }
    }
}
