package com.nitssrpi.NIT_SRPI.repository;

import com.nitssrpi.NIT_SRPI.model.ExternalAuthor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface ExternalAuthorRepository extends JpaRepository<ExternalAuthor, Long>, JpaSpecificationExecutor<ExternalAuthor> {
    boolean existsByCpf(String cpf);
    boolean existsByEmail(String email);

    Page<ExternalAuthor> findByOwnerId(Long ownerId, Pageable pageable);

}
