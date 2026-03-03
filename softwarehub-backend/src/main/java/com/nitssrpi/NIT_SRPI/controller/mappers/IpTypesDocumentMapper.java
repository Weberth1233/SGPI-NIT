package com.nitssrpi.NIT_SRPI.controller.mappers;

import com.nitssrpi.NIT_SRPI.controller.dto.IpTypesDocumentRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.IpTypesDocumentResponseDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.IpTypesRequestDTO;
import com.nitssrpi.NIT_SRPI.model.IpTypeDocument;
import com.nitssrpi.NIT_SRPI.repository.IpTypesRepository;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.springframework.beans.factory.annotation.Autowired;

@Mapper(componentModel = "spring", uses = {IpTypesMapper.class})
public abstract class IpTypesDocumentMapper {

    @Autowired
    IpTypesRepository ipTypesRepository;

    @Mapping(target = "ipType", expression = "java( ipTypesRepository.findById(dto.ipTypeId()).orElse(null))")
    public abstract IpTypeDocument toEntity(IpTypesDocumentRequestDTO dto);

    public abstract IpTypesDocumentResponseDTO toDTO(IpTypeDocument ipTypeDocument);
}
