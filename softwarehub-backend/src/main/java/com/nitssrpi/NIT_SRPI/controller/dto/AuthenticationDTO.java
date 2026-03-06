package com.nitssrpi.NIT_SRPI.controller.dto;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(name = "Autenticação")
public record AuthenticationDTO(String email, String password) {
}

