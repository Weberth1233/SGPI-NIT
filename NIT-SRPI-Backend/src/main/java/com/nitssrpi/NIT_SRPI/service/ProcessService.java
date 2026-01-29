package com.nitssrpi.NIT_SRPI.service;

import com.nitssrpi.NIT_SRPI.controller.dto.ProcessStatusCountDTO;
import com.nitssrpi.NIT_SRPI.model.*;
import com.nitssrpi.NIT_SRPI.model.Process;
import com.nitssrpi.NIT_SRPI.repository.IpTypesRepository;
import com.nitssrpi.NIT_SRPI.repository.ProcessRepository;
import com.nitssrpi.NIT_SRPI.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ProcessService {

    private final ProcessRepository repository;
    private final IpTypesRepository ipTypesRepository;
    private final UserRepository userRepository;

    @Transactional
    public Process save(Process process) {
        // 1. IMPORTANTE: Buscar o tipo de PI completo no banco para ter acesso à lista de documentos (RequiredDocuments)
        IpTypes type = ipTypesRepository.findById(process.getIpType().getId())
                .orElseThrow(() -> new RuntimeException("Tipo de PI não encontrado!"));
        // Vinculamos o objeto "vivo" do banco ao processo
        process.setIpType(type);
        // 2. Agora o loop vai funcionar porque o 'type' carregou os documentos
        if (type.getRequiredDocuments() != null && !type.getRequiredDocuments().isEmpty()) {
            for (IpTypeDocument docModelo : type.getRequiredDocuments()) {
                Attachment novoAnexo = new Attachment();
                novoAnexo.setDisplayName(docModelo.getDisplayName());
                // Aqui acontece a cópia que você perguntou: igualamos os caminhos!
                novoAnexo.setTemplateFilePath(docModelo.getTemplateFilePath());
                novoAnexo.setStatus("PENDING");
                novoAnexo.setProcess(process);
                // Adicionamos na lista do processo
                process.getAttachments().add(novoAnexo);
            }
        }
        process.setStatus(StatusProcess.EM_ANDAMENTO);
        // 3. Ao salvar o processo, o JPA salvará os Attachments automaticamente
        // (se você tiver o CascadeType.ALL ou PERSIST no mapeamento da lista de attachments)
        return repository.save(process);
    }

    public List<Process> getAllProcess() {
        return repository.findAll();
    }
//tesetHFDJHFJJ
    public List<ProcessStatusCountDTO> countProcessStatus(){
        return repository.countProcessStatus();
    }

}
