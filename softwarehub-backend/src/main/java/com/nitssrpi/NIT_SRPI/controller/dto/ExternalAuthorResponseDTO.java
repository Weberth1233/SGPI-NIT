package com.nitssrpi.NIT_SRPI.controller.dto;

public record ExternalAuthorResponseDTO(
        Long id, String fullName, String cpf, String email, boolean active
){}
