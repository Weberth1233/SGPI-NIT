package com.nitssrpi.NIT_SRPI.controller.mappers;

import com.nitssrpi.NIT_SRPI.controller.dto.ProcessRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.ProcessResponseDTO;
import com.nitssrpi.NIT_SRPI.model.IpTypes;
import com.nitssrpi.NIT_SRPI.model.Process;
import com.nitssrpi.NIT_SRPI.model.User;
import com.nitssrpi.NIT_SRPI.repository.UserRepository;
import org.mapstruct.AfterMapping;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.springframework.beans.factory.annotation.Autowired;

@Mapper(componentModel = "spring")
public abstract class ProcessMapper {

    @Autowired
    protected UserRepository userRepository;

    @Mapping(target = "id", ignore = true)
    public abstract Process toEntity(ProcessRequestDTO dto);

    public abstract ProcessResponseDTO toDTO(Process process);

    @AfterMapping
    protected void afterMapping(ProcessRequestDTO dto, @MappingTarget Process process) {

        // ipType
        if (dto.ipTypeId() != null) {
            IpTypes ipType = new IpTypes();
            ipType.setId(dto.ipTypeId());
            process.setIpType(ipType);
        }

        // creator
        if (dto.creatorId() != null) {
            User creator = new User();
            creator.setId(dto.creatorId());
            process.setCreator(creator);
        }

        // authors
        if (dto.authorIds() != null) {
            process.setAuthors(userRepository.findAllById(dto.authorIds()));
        }
    }
}
