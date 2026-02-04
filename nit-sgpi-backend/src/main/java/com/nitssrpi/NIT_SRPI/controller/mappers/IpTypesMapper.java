package com.nitssrpi.NIT_SRPI.controller.mappers;

import com.nitssrpi.NIT_SRPI.controller.dto.IpTypesRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.IpTypesResponseDTO;
import com.nitssrpi.NIT_SRPI.model.IpTypes;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface IpTypesMapper {
    IpTypes toEntity(IpTypesRequestDTO dto);
    IpTypesResponseDTO toDTO(IpTypes ipTypes);
}
