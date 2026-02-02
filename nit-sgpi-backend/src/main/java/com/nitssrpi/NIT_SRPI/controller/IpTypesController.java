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
import java.util.Optional;
//Mandando todas as atualizações do codigo para branch develop
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
    @PutMapping("{id}")
    public ResponseEntity<Object> updateIpTypes
    (@RequestBody @Valid IpTypesRequestDTO dto, @PathVariable("id") String id ) {
        var idIpTypes = Long.parseLong(id);
        //Buscando na base se existe alguem com esse id
        Optional<IpTypes> ipTypesOptional = service.getById(idIpTypes);
        //Se for vazio eu retorno notFound
        if(ipTypesOptional.isEmpty()){
            return ResponseEntity.notFound().build();
        }
        var ipTypes = ipTypesOptional.get();
        ipTypes.setName(dto.name());
        ipTypes.setFormStructure(dto.formStructure());
        service.update(ipTypes);
        return ResponseEntity.noContent().build();
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

    //Obter autor pelo id
    @DeleteMapping("{id}")
    public ResponseEntity<Object> deleteIpTypes
    (@PathVariable("id") String id) {
        var idIpTypes = Long.parseLong(id);
        //Buscando na base se existe alguem com esse id
        Optional<IpTypes> ipTypesOptional = service.getById(idIpTypes);
        //Se for vazio eu retorno notFound
        if(ipTypesOptional.isEmpty()){
            return ResponseEntity.notFound().build();
        }
        //Se não eu deleto
        service.delete(ipTypesOptional.get());
        return ResponseEntity.noContent().build();
    }
}
