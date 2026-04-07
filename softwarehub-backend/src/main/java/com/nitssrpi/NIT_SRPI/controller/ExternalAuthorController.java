package com.nitssrpi.NIT_SRPI.controller;

import com.nitssrpi.NIT_SRPI.controller.dto.ExternalAuthorRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.ExternalAuthorResponseDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.ProcessResponseDTO;
import com.nitssrpi.NIT_SRPI.controller.mappers.ExternalAuthorMapper;
import com.nitssrpi.NIT_SRPI.model.ExternalAuthor;
import com.nitssrpi.NIT_SRPI.model.StatusProcess;
import com.nitssrpi.NIT_SRPI.service.ExternalAuthorService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("external_author")
@RequiredArgsConstructor
@Tag(name = "Usuários externos")
public class ExternalAuthorController implements GenericController{
    private final ExternalAuthorService service;
    private final ExternalAuthorMapper mapper;

    @PostMapping
    @Operation(summary = "Salvar", description = "Cadastrar novo usuário externo")
    @ApiResponses({
            @ApiResponse(responseCode = "201", description = "Cadastrado com sucesso!"),
            @ApiResponse(responseCode = "422", description = "Erro de validação!"),
    })
    public ResponseEntity<Object> save(@RequestBody @Valid ExternalAuthorRequestDTO dto) {
        ExternalAuthor externalAuthor = mapper.toEntity(dto);
        service.save(externalAuthor);
        URI location = generateHeaderLocation(externalAuthor.getId());
        return ResponseEntity.created(location).build();
    }

    @GetMapping
    @Operation(summary = "Obter", description = "Obter todos os usuários externos")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Sucesso na busca!"),
    })
    public ResponseEntity<List<ExternalAuthorResponseDTO>> allTypesOfProperty(){
        List<ExternalAuthor> result = service.getAll();
        List<ExternalAuthorResponseDTO> list = result.stream().map(mapper::toDTO).toList();
        return ResponseEntity.ok(list);
    }

    @PutMapping("{id}")
    @Operation(summary = "Atualizar", description = "Atualizar usuário externo passando o ID como paramêtro")
    @ApiResponses({
            @ApiResponse(responseCode = "204", description = "Atualizado com sucesso!"),
            @ApiResponse(responseCode = "404", description = "Usuário externo não encontrado!"),
    })
    public ResponseEntity<Object> updateExternalAuthor
            (@RequestBody @Valid ExternalAuthorRequestDTO dto, @PathVariable("id") String id ) {
        var externalAuthorId = Long.parseLong(id);
        //Buscando na base se existe alguem com esse id
        Optional<ExternalAuthor> externalAuthorOptional = service.getById(externalAuthorId);
        //Se for vazio eu retorno notFound
        if(externalAuthorOptional.isEmpty()){
            return ResponseEntity.notFound().build();
        }
        var externalAuthor = externalAuthorOptional.get();
        externalAuthor.setFullName(dto.fullName());
        externalAuthor.setCpf(dto.cpf());
        externalAuthor.setEmail(dto.email());
        service.update(externalAuthor);
        return ResponseEntity.noContent().build();
    }

    //Obter autor pelo id
    @DeleteMapping("{id}")
    @Operation(summary = "Deletar", description = "Deletar usuário externo passando o ID como paramêtro")
    @ApiResponses({
            @ApiResponse(responseCode = "204", description = "Deletado com sucesso!"),
            @ApiResponse(responseCode = "404", description = "Usuário externo não encontrado!"),
    })
    public ResponseEntity<Object> deleteIpTypes
    (@PathVariable("id") String id) {
        var externalAuthorId = Long.parseLong(id);
        //Buscando na base se existe alguem com esse id
        Optional<ExternalAuthor> externalAuthorOptional = service.getById(externalAuthorId);
        //Se for vazio eu retorno notFound
        if(externalAuthorOptional.isEmpty()){
            return ResponseEntity.notFound().build();
        }
        //Se não eu deleto
        service.delete(externalAuthorOptional.get());
        return ResponseEntity.noContent().build();
    }

    //Essa url vai ser apenas para usuarios comuns
    @GetMapping("/user/external_authors")
    @Operation(summary = "Pesquisar autores externos cadastrados pelo o usuário logado", description = "Pesquisar autores externos cadastrados pelo o usuário logado passando o nome, cpf, email, página ou tamanho da página como paramêtro")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Busca realizada com sucesso!"),
            @ApiResponse(responseCode = "404", description = "Recurso não encontrado!"),
    })
    public ResponseEntity<Page<ExternalAuthorResponseDTO>> pagedUserExternalAuthors(
            @RequestParam(value = "search", required = false) String search,
            @RequestParam(defaultValue = "0") Integer page,
            @RequestParam(name = "page-size", defaultValue = "10") Integer pageSize
    ) {
        Page<ExternalAuthorResponseDTO> result =
                service.userExternalAuthors(search,page, pageSize)
                        .map(mapper::toDTO);

        return ResponseEntity.ok(result);
    }
}
