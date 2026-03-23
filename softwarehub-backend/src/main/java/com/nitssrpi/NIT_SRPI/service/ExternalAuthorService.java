package com.nitssrpi.NIT_SRPI.service;
import com.nitssrpi.NIT_SRPI.Infra.security.SecurityService;
import com.nitssrpi.NIT_SRPI.controller.exceptions.DuplicateRecordException;
import com.nitssrpi.NIT_SRPI.model.*;
import com.nitssrpi.NIT_SRPI.repository.ExternalAuthorRepository;
import com.nitssrpi.NIT_SRPI.repository.specs.ExternalAuthorSpecs;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ExternalAuthorService {
    private final ExternalAuthorRepository repository;
    private final SecurityService securityService;

    public ExternalAuthor save(ExternalAuthor externalAuthor){
        // Validação preventiva
        if (repository.existsByCpf(externalAuthor.getCpf())) {
            throw new DuplicateRecordException("O CPF " + externalAuthor.getCpf() + " já está cadastrado no sistema!.");
        }
        if (repository.existsByEmail(externalAuthor.getEmail())) {
            throw new DuplicateRecordException("O Email " + externalAuthor.getEmail() + " já está cadastrado no sistema!.");
        }
        User user = securityService.getAuthenticatedUser();
        externalAuthor.setOwner(user);
        return repository.save(externalAuthor);
    }

    public void update(ExternalAuthor externalAuthor){
        if(externalAuthor.getId() == null){
            throw new IllegalArgumentException("Para atualizar é necessário que o usuário esteja cadastrado!");
        }
        repository.save(externalAuthor);
    }

    public Optional<ExternalAuthor> getById(Long id){
        return repository.findById(id);
    }

    public List<ExternalAuthor> getAll(){
        return repository.findAll();
    }

    public void delete(ExternalAuthor externalAuthor){
        repository.delete(externalAuthor);
    }

    public Page<ExternalAuthor> userExternalAuthors(String fullName, String cpf, String email, Integer page, Integer pageSize) {
        // 1. Pega o usuário logado
        User user = securityService.getAuthenticatedUser();

        Specification<ExternalAuthor> specs = Specification.where(ExternalAuthorSpecs.equalOwnerId(user.getId()));
            // 3. Adiciona os filtros dinâmicos (igual ao searchProcess)
        if (fullName != null && !fullName.isEmpty()) {
            specs = specs.and(ExternalAuthorSpecs.likeFullName(fullName));
        }
        if (cpf != null && !cpf.isEmpty()) {
            specs = specs.and(ExternalAuthorSpecs.equalCpf(cpf));
        }
        if (email != null && !email.isEmpty()) {
            specs = specs.and(ExternalAuthorSpecs.likeEmail(email));
        }
        // 4. Configura a paginação
        Pageable pageable = PageRequest.of(page, pageSize);
        // 5. Chama o findAll (que vem do JpaSpecificationExecutor)
        return repository.findAll(specs, pageable);
    }
}

