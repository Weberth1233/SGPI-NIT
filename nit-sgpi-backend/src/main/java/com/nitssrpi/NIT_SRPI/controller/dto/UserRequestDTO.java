package com.nitssrpi.NIT_SRPI.controller.dto;

import com.nitssrpi.NIT_SRPI.model.UserRole;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Past;
import jakarta.validation.constraints.Pattern;
import org.springframework.data.annotation.LastModifiedDate;

import java.time.LocalDate;

public record UserRequestDTO(
        @NotBlank(message = "Campo obrigatório!")
        String userName,
        @Email(message = "Email inválido!")
        String email,
        @NotBlank
        String password,
        @NotBlank(message = "O telefone é obrigatório")
        @Pattern(
                regexp = "^\\(?([1-9]{2})\\)?[-. ]?([9])?([-  ]?)?(\\d{4})[-. ]?(\\d{4})$",
                message = "O número de telefone informado é inválido"
        )
        String phoneNumber,
        @Past(message = "Não pode ser uma data futura!")
        LocalDate birthDate,
        String profession,
        @NotBlank(message = "Campo obrigatório!")
        String fullName,
        UserRole role,
        Boolean isEnabled,
        AddressRequestDTO address) {
}
