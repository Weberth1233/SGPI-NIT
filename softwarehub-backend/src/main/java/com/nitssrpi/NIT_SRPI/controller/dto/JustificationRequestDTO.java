package com.nitssrpi.NIT_SRPI.controller.dto;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(name = "Justificativa")
public record JustificationRequestDTO(
        Long processId,
        String reason
){
}
