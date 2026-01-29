package com.nitssrpi.NIT_SRPI.controller.dto;

import java.time.LocalDate;

public record UserResponseDTO(Long id, String userName, String email, String password,
                              String phoneNumber,
                              LocalDate birthDate,String profession, String fullName, String role, Boolean isEnabled,
                              AddressResponseDTO address
) {

}
