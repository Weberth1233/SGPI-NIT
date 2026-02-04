package com.nitssrpi.NIT_SRPI.controller.mappers;

import com.nitssrpi.NIT_SRPI.controller.dto.AttachmentResponseDTO;
import com.nitssrpi.NIT_SRPI.model.Attachment;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface AttachmentMapper {
    AttachmentResponseDTO toDTO(Attachment attachment);
}
