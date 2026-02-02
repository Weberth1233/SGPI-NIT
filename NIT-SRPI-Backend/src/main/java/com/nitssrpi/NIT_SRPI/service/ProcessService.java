package com.nitssrpi.NIT_SRPI.service;

import com.nitssrpi.NIT_SRPI.controller.dto.ProcessStatusCountDTO;
import com.nitssrpi.NIT_SRPI.model.*;
import com.nitssrpi.NIT_SRPI.model.Process;
import com.nitssrpi.NIT_SRPI.repository.IpTypesRepository;
import com.nitssrpi.NIT_SRPI.repository.ProcessRepository;
import com.nitssrpi.NIT_SRPI.repository.UserRepository;
import com.nitssrpi.NIT_SRPI.repository.specs.ProcessSpecs;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

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

    public Page<Process> userProcesses(Long createdId, Integer page, Integer pageSize){
            Pageable pageable = PageRequest.of(page, pageSize, Sort.by(Sort.Direction.DESC, "createdAt"));
        Page<Process> resultPage = repository.findByCreatorId(createdId, pageable);
        return resultPage;
    }


    public Page<Process> searchProcess(String title, StatusProcess statusProcess, Integer page, Integer pageSize){
        Specification<Process> specs = Specification.where((root, query, cb) -> cb.conjunction());
        if(title != null){
            specs = specs.and(ProcessSpecs.likeTitle(title));
        }
        if(statusProcess != null){
            specs = specs.and(ProcessSpecs.equalStatusProcess(statusProcess));
        }
        Pageable pageRequest = PageRequest.of(page, pageSize);
        return repository.findAll(specs, pageRequest);
    }

    public Optional<Process> getById(Long id){
        return repository.findById(id);
    }

    public void delete(Process process){
        repository.delete(process);
    }

    public List<Process> getAllProcess() {
        return repository.findAll();
    }

    public List<ProcessStatusCountDTO> countProcessStatus(){
        return repository.countProcessStatus();
    }

}
