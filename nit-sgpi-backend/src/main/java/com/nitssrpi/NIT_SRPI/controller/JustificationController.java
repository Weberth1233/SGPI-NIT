package com.nitssrpi.NIT_SRPI.controller;
import com.nitssrpi.NIT_SRPI.controller.dto.JustificationRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.JustificationResponseDTO;
import com.nitssrpi.NIT_SRPI.controller.mappers.JustificationMapper;
import com.nitssrpi.NIT_SRPI.model.Justification;
import com.nitssrpi.NIT_SRPI.model.Process;
import com.nitssrpi.NIT_SRPI.service.JustificationService;
import com.nitssrpi.NIT_SRPI.service.ProcessService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("justification")
@RequiredArgsConstructor
public class JustificationController implements  GenericController{
    private final JustificationService service;
    private final ProcessService processService;
    private final JustificationMapper mapper;

    @PostMapping
    public ResponseEntity<Void> save(@RequestBody @Valid JustificationRequestDTO dto) {

        Justification saved = service.save(dto.processId(), dto.reason());

        URI location = generateHeaderLocation(saved.getId());

        return ResponseEntity.created(location).build();
    }

    @GetMapping("process/{id}")
    public ResponseEntity<List<JustificationResponseDTO>> allJusticationProcess(@PathVariable("id") Long id){
        List<Justification> results = service.findByProcessJustification(id);
        List<JustificationResponseDTO> list = results.stream().map(mapper::toDTO).toList();
        return ResponseEntity.ok(list);
    }

    @PutMapping("{id}")
    public ResponseEntity<Object> updateIpTypes
            (@RequestBody @Valid JustificationRequestDTO dto, @PathVariable("id") String id ) {
        var idJustification = Long.parseLong(id);
        //Buscando na base se existe alguem com esse id
        Optional<Justification> justificationOptional = service.getById(idJustification);
        //Se for vazio eu retorno notFound
        if(justificationOptional.isEmpty()){
            return ResponseEntity.notFound().build();
        }
        var justification = justificationOptional.get();
        justification.setReason(dto.reason());

        Optional<Process> process  = processService.getById(dto.processId());
        process.ifPresent(justification::setProcess);

        service.update(justification);
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("{id}")
    public ResponseEntity<Object> deleteIpTypes
            (@PathVariable("id") String id) {
        var idJustification = Long.parseLong(id);
        //Buscando na base se existe alguem com esse id
        Optional<Justification> justificationOptional = service.getById(idJustification);
        //Se for vazio eu retorno notFound
        if(justificationOptional.isEmpty()){
            return ResponseEntity.notFound().build();
        }
        //Se não eu deleto
        service.delete(justificationOptional.get());
        return ResponseEntity.noContent().build();
    }
}
