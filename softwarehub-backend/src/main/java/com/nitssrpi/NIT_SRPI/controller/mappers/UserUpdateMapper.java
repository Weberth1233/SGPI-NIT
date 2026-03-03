package com.nitssrpi.NIT_SRPI.controller.mappers;

import com.nitssrpi.NIT_SRPI.controller.dto.UserUpdateDTO;
import com.nitssrpi.NIT_SRPI.model.User;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface UserUpdateMapper {

    User toEntity(UserUpdateDTO dto);
}
