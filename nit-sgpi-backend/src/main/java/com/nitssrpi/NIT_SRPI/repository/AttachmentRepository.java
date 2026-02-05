package com.nitssrpi.NIT_SRPI.repository;

import com.nitssrpi.NIT_SRPI.model.Attachment;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

List<Attachment> findByProjectId(Long ipTypeId);

public interface AttachmentRepository extends JpaRepository<Attachment, Long> {
}
