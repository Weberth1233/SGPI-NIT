package com.nitssrpi.NIT_SRPI.controller.mappers;
import com.nitssrpi.NIT_SRPI.controller.dto.UserRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.UserResponseDTO;
import com.nitssrpi.NIT_SRPI.model.User;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface UserMapper {
    User toEntity(UserRequestDTO dto);
    @Mapping(source = "username", target = "userName")
    UserResponseDTO toDTO(User user);

}
