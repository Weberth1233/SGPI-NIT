package com.nitssrpi.NIT_SRPI.controller.dto;
import java.time.LocalDate;

public record UserSummaryDTO(Long id, String userName, String email,
                             String phoneNumber,
                             LocalDate birthDate, String profession, String fullName) {
}
