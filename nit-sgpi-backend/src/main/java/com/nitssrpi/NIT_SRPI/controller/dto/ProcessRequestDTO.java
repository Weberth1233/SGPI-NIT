package com.nitssrpi.NIT_SRPI.controller.dto;

import java.util.List;
import java.util.Map;

public record ProcessRequestDTO(String title, Long ipTypeId, List<Long> authorIds, Map<String, Object> formData,boolean isFeatured, Long creatorId) {
}
