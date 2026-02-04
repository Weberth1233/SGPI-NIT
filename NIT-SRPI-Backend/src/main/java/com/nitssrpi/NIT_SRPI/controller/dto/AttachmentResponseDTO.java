package com.nitssrpi.NIT_SRPI.controller.dto;

public record AttachmentResponseDTO(Long id,String displayName, String status, String templateDownloadUrl,String signedFileUrl) {
}
