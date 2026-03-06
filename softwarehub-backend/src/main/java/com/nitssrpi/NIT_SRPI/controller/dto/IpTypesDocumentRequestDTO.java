package com.nitssrpi.NIT_SRPI.controller.dto;

import com.nitssrpi.NIT_SRPI.model.IpTypes;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
@Schema(name = "Documento Tipo propriedade intelectual")
public record IpTypesDocumentRequestDTO (
        @NotBlank(message = "Campo display não pode ser vazio!")
    String displayName,
        @NotBlank(message = "Campo template não pode ser vazio!")
    String templateFilePath,
        @NotBlank(message = "Campo id não pode ser vazio!")
    Long ipTypeId
){}
