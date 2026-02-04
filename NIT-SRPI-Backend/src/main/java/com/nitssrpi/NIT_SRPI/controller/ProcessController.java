package com.nitssrpi.NIT_SRPI.controller;
import com.nitssrpi.NIT_SRPI.controller.dto.ProcessRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.ProcessResponseDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.ProcessStatusCountDTO;
import com.nitssrpi.NIT_SRPI.controller.mappers.ProcessMapper;
import com.nitssrpi.NIT_SRPI.model.Process;
import com.nitssrpi.NIT_SRPI.service.ProcessService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;
import java.net.URI;
import java.util.List;

@RestController
@RequestMapping("process")
@RequiredArgsConstructor
public class ProcessController {

    private final ProcessService service;
    private final ProcessMapper mapper;

    @PostMapping
    public ResponseEntity<Object> save(@RequestBody @Valid ProcessRequestDTO dto) {
        Process process = mapper.toEntity(dto);
        service.save(process);
        URI location = generateHeaderLocation(process.getId());
        return ResponseEntity.created(location).build();
    }

    @GetMapping
    public ResponseEntity<List<ProcessResponseDTO>> allProcess(){
        List<Process> result = service.getAllProcess();
        List<ProcessResponseDTO> list = result.stream().map(mapper::toDTO).toList();
        return ResponseEntity.ok(list);
    }

    @GetMapping("/status/amount")
    public ResponseEntity<List<ProcessStatusCountDTO>> countStatus(){
        return ResponseEntity.ok(service.countProcessStatus());
    }

    private URI generateHeaderLocation(Long id) {
        return ServletUriComponentsBuilder.
                fromCurrentRequest().
                path("/{id}")
                .buildAndExpand(id).
                toUri();
    }
}
