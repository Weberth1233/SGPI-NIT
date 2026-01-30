package com.nitssrpi.NIT_SRPI.controller;
import com.nitssrpi.NIT_SRPI.controller.dto.ProcessRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.ProcessResponseDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.ProcessStatusCountDTO;
import com.nitssrpi.NIT_SRPI.controller.mappers.ProcessMapper;
import com.nitssrpi.NIT_SRPI.model.Process;
import com.nitssrpi.NIT_SRPI.model.StatusProcess;
import com.nitssrpi.NIT_SRPI.service.ProcessService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;
import java.net.URI;
import java.util.List;
import org.springframework.data.domain.Page;

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
    //Essa url vai ser apenas para admin
    @GetMapping
    public ResponseEntity<Page<ProcessResponseDTO>> pagedSearch( @RequestParam(value = "title", required = false) String title,
                                             @RequestParam(value = "status-process", required = false) StatusProcess statusProcess,
                                             @RequestParam(value = "page", defaultValue = "0") Integer page,
                                             @RequestParam(value = "page-size",  defaultValue = "10") Integer pageSize){
       Page<Process> resultPage = service.searchProcess(title, statusProcess, page, pageSize);
       Page<ProcessResponseDTO> result = resultPage.map(mapper::toDTO);
       return ResponseEntity.ok(result);
    }
    //Essa url vai ser apenas para usuarios comuns
    @GetMapping("/user/processes")
    public ResponseEntity<Page<ProcessResponseDTO>> pagedUserProcesses(
            @RequestParam("id-user") Long id,
            @RequestParam(defaultValue = "0") Integer page,
            @RequestParam(name = "page-size", defaultValue = "10") Integer pageSize
    ) {
        Page<ProcessResponseDTO> result =
                service.userProcesses(id, page, pageSize)
                        .map(mapper::toDTO);

        return ResponseEntity.ok(result);
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
