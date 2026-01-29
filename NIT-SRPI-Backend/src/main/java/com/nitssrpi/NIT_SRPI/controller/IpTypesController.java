package com.nitssrpi.NIT_SRPI.controller;

import com.nitssrpi.NIT_SRPI.controller.dto.IpTypesRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.IpTypesResponseDTO;
import com.nitssrpi.NIT_SRPI.controller.mappers.IpTypesMapper;
import com.nitssrpi.NIT_SRPI.model.IpTypes;
import com.nitssrpi.NIT_SRPI.service.IpTypesService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("ip_types")
@RequiredArgsConstructor
public class IpTypesController implements GenericController{
    private final IpTypesService service;
    private final IpTypesMapper mapper;

    @PostMapping
    public ResponseEntity<Object> save(@RequestBody @Valid IpTypesRequestDTO dto) {
        IpTypes ipTypes = mapper.toEntity(dto);
        service.save(ipTypes);
        URI location = generateHeaderLocation(ipTypes.getId());
        return ResponseEntity.created(location).build();

    }

    @GetMapping
    public ResponseEntity<List<IpTypesResponseDTO>> allTypesOfProperty(){
        List<IpTypes> result = service.allTypesOfProperty();
        List<IpTypesResponseDTO> list = result.stream().map(mapper::toDTO).toList();
        return ResponseEntity.ok(list);
    }

    //Obter autor pelo id
    @GetMapping("{id}")
    public ResponseEntity<IpTypesResponseDTO> getDetails
            (@PathVariable("id") String id) {

        var idIpTypes = Long.parseLong(id);

        return service.getById(idIpTypes).map(ipTypes -> {
            IpTypesResponseDTO dto = mapper.toDTO(ipTypes);
            return ResponseEntity.ok(dto);
        }).orElseGet(() -> ResponseEntity.notFound().build());
    }


}
