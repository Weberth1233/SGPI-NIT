package com.nitssrpi.NIT_SRPI.controller;
import com.nitssrpi.NIT_SRPI.controller.dto.IpTypesResponseDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.UserRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.UserResponseDTO;
import com.nitssrpi.NIT_SRPI.controller.mappers.UserMapper;
import com.nitssrpi.NIT_SRPI.model.Address;
import com.nitssrpi.NIT_SRPI.model.User;
import com.nitssrpi.NIT_SRPI.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;
import java.net.URI;

@RestController
@RequestMapping("users")
@RequiredArgsConstructor
public class UserController {
    private final UserService service;
    private final UserMapper mapper;
//    private final AddressMapper mapperAddress;


    @PostMapping
    public ResponseEntity<Object> save(@RequestBody @Valid UserRequestDTO dto) {
        User user = mapper.toEntity(dto);
        service.save(user);
        URI location = generateHeaderLocation(user.getId());
        return ResponseEntity.created(location).build();
    }

    //Obter autor pelo id
    @GetMapping("{id}")
    public ResponseEntity<UserResponseDTO> getDetailsUser
    (@PathVariable("id") String id) {
        var idUser = Long.parseLong(id);
        return service.getUserById(idUser).map(user -> {
            UserResponseDTO dto = mapper.toDTO(user);
            return ResponseEntity.ok(dto);
        }).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PutMapping("{id}")
    public ResponseEntity<Object> updateUser(@PathVariable("id") String id, @RequestBody @Valid UserRequestDTO dto){
        var idUser = Long.parseLong(id);

        return service.getUserById(idUser).map(user -> {
            //Pegando o usuario do dto e criando um user
            User auxUser = mapper.toEntity(dto);

            //Passando novos valores para o usuario encontrado com o id passado como parametro
            user.setUserName(auxUser.getUserName());
            user.setEmail(auxUser.getEmail());
            user.setPassword(auxUser.getPassword());
            user.setPhoneNumber(auxUser.getPhoneNumber());
            user.setBirthDate(auxUser.getBirthDate());
            user.setProfession(auxUser.getProfession());
            user.setRole(auxUser.getRole());
            user.setIsEnabled(auxUser.getIsEnabled());

            user.getAddress().setStreet(auxUser.getAddress().getStreet());
            user.getAddress().setNumber(auxUser.getAddress().getNumber());
            user.getAddress().setComplement(auxUser.getAddress().getComplement());
            user.getAddress().setNeighborhood(auxUser.getAddress().getNeighborhood());
            user.getAddress().setCity(auxUser.getAddress().getCity());
            user.getAddress().setZipCode(auxUser.getAddress().getZipCode());

            service.update(user);
            return ResponseEntity.noContent().build();
        }).orElseGet(() -> ResponseEntity.notFound().build());

    }

//referenciando issue #1
    private URI generateHeaderLocation(Long id) {
        return ServletUriComponentsBuilder.
                fromCurrentRequest().
                path("/{id}")
                .buildAndExpand(id).
                toUri();
    }
}
