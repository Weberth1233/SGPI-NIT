package com.nitssrpi.NIT_SRPI.controller.dto;

import jakarta.validation.constraints.Email;
import org.hibernate.validator.constraints.br.CPF;

public record ExternalAuthorRequestDTO(String fullName,
                                       @CPF(message = "CPF inválido!")
                                       String cpf,
                                       @Email(message = "Email inválido!")
                                       String email) {
}
