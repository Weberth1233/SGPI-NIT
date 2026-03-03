package com.nitssrpi.NIT_SRPI.controller.dto;

import com.nitssrpi.NIT_SRPI.model.FormStructure;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record IpTypesRequestDTO(
        @NotBlank(message = "Campo nome não pode ser vazio!")
        String name,
        @NotNull(message = "Campos não podem ser vazios!")
        FormStructure formStructure) {

}
