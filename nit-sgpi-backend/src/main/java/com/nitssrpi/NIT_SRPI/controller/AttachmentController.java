package com.nitssrpi.NIT_SRPI.controller;
import com.nitssrpi.NIT_SRPI.controller.dto.AttachmentResponseDTO;
import com.nitssrpi.NIT_SRPI.controller.mappers.AttachmentMapper;
import com.nitssrpi.NIT_SRPI.model.Attachment;
import com.nitssrpi.NIT_SRPI.repository.AttachmentRepository;
import com.nitssrpi.NIT_SRPI.service.AttachmentService;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequestMapping("attachments")
@RequiredArgsConstructor
public class AttachmentController {
    private final AttachmentService attachmentService;
    private final AttachmentMapper mapper;
    private final AttachmentRepository attachmentRepository;

    @GetMapping
    public ResponseEntity<List<AttachmentResponseDTO>> getAllAttachments() {
        List<Attachment> result = attachmentRepository.findAll();
        List<AttachmentResponseDTO> list = result.stream().map(mapper::toDTO).toList();
        return ResponseEntity.ok(list);
    }

    @GetMapping("/download/template/{id}")
    public ResponseEntity<Resource> downloadTemplate(@PathVariable Long id){
        Attachment att = attachmentRepository.findById(id).orElseThrow();
        // Busca sempre o caminho do template
        Resource resource = attachmentService.loadFile(att.getTemplateFilePath());

        return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_PDF)
                .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"MODELO_" + att.getDisplayName() + ".pdf\"")
                .body(resource);
    }

    @GetMapping("/download/signed/{id}")
    public ResponseEntity<Resource> downloadSigned(@PathVariable Long id) {
        Attachment att = attachmentRepository.findById(id).orElseThrow();

        if (att.getSignedFilePath() == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
        // Busca o caminho do arquivo assinado
        Resource resource = attachmentService.loadFile(att.getSignedFilePath());

        return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_PDF)
                .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"ASSINADO_" + att.getDisplayName() + ".pdf\"")
                .body(resource);
    }

    @PostMapping("/upload/{id}")
    public ResponseEntity<String> upload(@PathVariable Long id, @RequestParam("file") MultipartFile file) {
        Attachment att = attachmentRepository.findById(id).orElseThrow();
        attachmentService.saveSignedFile(file, att);
        attachmentRepository.save(att);
        return ResponseEntity.ok("Enviado com sucesso!");
    }
    //teste backend
}
