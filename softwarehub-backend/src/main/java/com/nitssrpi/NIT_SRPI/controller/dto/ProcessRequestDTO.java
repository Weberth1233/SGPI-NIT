package com.nitssrpi.NIT_SRPI.controller.dto;

import io.swagger.v3.oas.annotations.media.Schema;

import java.util.List;
import java.util.Map;
@Schema(name = "Processo")
public record ProcessRequestDTO(String title, Long ipTypeId, List<Long> authorIds, List<Long> externalAuthorsIds, Map<String, Object> formData,boolean isFeatured) {
}
