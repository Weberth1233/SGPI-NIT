package com.nitssrpi.NIT_SRPI.controller.dto;

import com.nitssrpi.NIT_SRPI.model.IpTypes;
import jakarta.validation.constraints.NotBlank;

public record IpTypesDocumentRequestDTO (
        @NotBlank(message = "Campo display não pode ser vazio!")
    String displayName,
        @NotBlank(message = "Campo template não pode ser vazio!")
    String templateFilePath,
        @NotBlank(message = "Campo id não pode ser vazio!")
    Long ipTypeId
){}
