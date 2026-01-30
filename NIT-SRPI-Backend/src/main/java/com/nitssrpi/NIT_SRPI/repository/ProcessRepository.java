package com.nitssrpi.NIT_SRPI.repository;

import com.nitssrpi.NIT_SRPI.controller.dto.ProcessStatusCountDTO;
import com.nitssrpi.NIT_SRPI.model.Process;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface ProcessRepository extends JpaRepository<Process, Long>, JpaSpecificationExecutor<Process> {

    @Query("""
            SELECT p.status AS status,
            COUNT(p) AS amount
            FROM Process p
            GROUP BY p.status
           """)
    List<ProcessStatusCountDTO> countProcessStatus();

    Page<Process> findByCreatorId(Long creatorId, Pageable pageable);
}
