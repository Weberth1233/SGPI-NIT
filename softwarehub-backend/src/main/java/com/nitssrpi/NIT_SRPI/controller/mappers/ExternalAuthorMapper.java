package com.nitssrpi.NIT_SRPI.controller.mappers;
import com.nitssrpi.NIT_SRPI.controller.dto.ExternalAuthorRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.ExternalAuthorResponseDTO;
import com.nitssrpi.NIT_SRPI.model.ExternalAuthor;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public abstract class ExternalAuthorMapper {

//    @Autowired
//    UserRepository userRepository;

//    @Mapping(target = "owner", expression = "java( userRepository.findById(dto.userId()).orElse(null))")
    public abstract ExternalAuthor toEntity(ExternalAuthorRequestDTO dto);
    public abstract ExternalAuthorResponseDTO toDTO(ExternalAuthor externalAuthor);
}
