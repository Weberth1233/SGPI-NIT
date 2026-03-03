package com.nitssrpi.NIT_SRPI.controller.dto;

import com.nitssrpi.NIT_SRPI.model.UserRole;

public record LoginResponseDTO(String token, UserRole role) {
}
