package com.nitssrpi.NIT_SRPI.controller;
import com.nitssrpi.NIT_SRPI.controller.dto.*;
import com.nitssrpi.NIT_SRPI.controller.mappers.ProcessMapper;
import com.nitssrpi.NIT_SRPI.model.IpTypes;
import com.nitssrpi.NIT_SRPI.model.Process;
import com.nitssrpi.NIT_SRPI.model.StatusProcess;
import com.nitssrpi.NIT_SRPI.model.User;
import com.nitssrpi.NIT_SRPI.service.IpTypesService;
import com.nitssrpi.NIT_SRPI.service.ProcessService;
import com.nitssrpi.NIT_SRPI.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.mapstruct.control.MappingControl;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;
import java.net.URI;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;

@RestController
@RequestMapping("process")
@RequiredArgsConstructor
public class ProcessController implements GenericController{
    private final IpTypesService ipTypesService;
    private final UserService userService;
    private final ProcessService service;
    private final ProcessMapper mapper;

    @PostMapping
    public ResponseEntity<Object> save(@RequestBody @Valid ProcessRequestDTO dto) {
        Process process = mapper.toEntity(dto);
        service.save(process);
        URI location = generateHeaderLocation(process.getId());
        return ResponseEntity.created(location).build();
    }

    //Obter autor pelo id
    @PutMapping("{id}")
    public ResponseEntity<Object> updateIpTypes
    (@RequestBody @Valid ProcessRequestDTO dto, @PathVariable("id") String id ) {
        var idIpTypes = Long.parseLong(id);
        //Buscando na base se existe alguem com esse id
        Optional<Process> processOptional = service.getById(idIpTypes);
        //Se for vazio eu retorno notFound
        if(processOptional.isEmpty()){
            return ResponseEntity.notFound().build();
        }
        var process = processOptional.get();
        process.setTitle(dto.title());
        //Pesquisar no service de usuarios os usuarios e trazer ele pra cá novamente
        process.setFeatured(dto.isFeatured());
        process.setFormData(dto.formData());
        //Adicionando lista de users
        List<User> users = new ArrayList<User>();
        for (Long authorId : dto.authorIds()) {
            System.out.println(authorId);
            var user = userService.getUserById(authorId);
            user.ifPresent(users::add);
        }
        if(!users.isEmpty()){
            process.setAuthors(users);
        }
        Optional<User> user = userService.getUserById(dto.creatorId());
        user.ifPresent(process::setCreator);

        //Pesquisar no service de iptypes
        Optional<IpTypes> ipTypes = ipTypesService.getById(dto.ipTypeId());
        System.out.println(ipTypes);

        ipTypes.ifPresent(process::setIpType);

        service.update(process);
        return ResponseEntity.noContent().build();
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

    @GetMapping("{id}")
    public ResponseEntity<ProcessResponseDTO> getDetails
    (@PathVariable("id") String id) {
        var idProcess = Long.parseLong(id);
        return service.getById(idProcess).map(process -> {
            ProcessResponseDTO dto = mapper.toDTO(process);
            return ResponseEntity.ok(dto);
        }).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @GetMapping("/status/amount")
    public ResponseEntity<List<ProcessStatusCountDTO>> countStatus(){
        return ResponseEntity.ok(service.countProcessStatus());
    }

    @DeleteMapping("{id}")
    public ResponseEntity<Object> deleteIpTypes
            (@PathVariable("id") String id) {
        var idProcess = Long.parseLong(id);
        //Buscando na base se existe alguem com esse id
        Optional<Process> processOptional = service.getById(idProcess);
        //Se for vazio eu retorno notFound
        if(processOptional.isEmpty()){
            return ResponseEntity.notFound().build();
        }
        //Se não eu deleto
        service.delete(processOptional.get());
        return ResponseEntity.noContent().build();
    }
// Para atualização do status do processo    
    @PutMapping("/{id}/status")
    public ResponseEntity<Object> updateStatus(
        @PathVariable Long id,
        @RequestBody @Valid ProcessStatusUpdateDTO dto
    ){ 
        // CORREÇÃO: Usando a variável 'service' declarada na linha 33
        service.updateStatus(id, dto);
        return ResponseEntity.noContent().build();
    }
}
