package com.nitssrpi.NIT_SRPI.controller.dto;

import com.nitssrpi.NIT_SRPI.model.FormStructure;

public record IpTypesResponseDTO(
        Long id,
        String name,
        FormStructure formStructure
) {
}
