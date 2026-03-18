package com.nitssrpi.NIT_SRPI.controller.dto;

import com.nitssrpi.NIT_SRPI.model.FormStructure;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
@Schema(name = "Tipo propriedade intelectual")
public record IpTypesRequestDTO(
        @NotBlank(message = "Campo nome não pode ser vazio!")
        String name,
        @NotBlank(message = "Campo cor não pode ser vazio!")
        String color,
        @NotNull(message = "Campos não podem ser vazios!")
        FormStructure formStructure) {

}
