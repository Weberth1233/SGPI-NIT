package com.nitssrpi.NIT_SRPI.controller;
import com.nitssrpi.NIT_SRPI.controller.dto.IpTypesDocumentRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.IpTypesDocumentResponseDTO;
import com.nitssrpi.NIT_SRPI.controller.mappers.IpTypesDocumentMapper;
import com.nitssrpi.NIT_SRPI.model.IpTypeDocument;
import com.nitssrpi.NIT_SRPI.service.IpTypesDocumentService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.List;

@RestController
@RequestMapping("ip_types_documents")
@RequiredArgsConstructor
@Tag(name = "Documentos Tipo Propriedade Intelectual")
public class IpTypeDocumentController implements  GenericController {
    private final IpTypesDocumentService service;
    private final IpTypesDocumentMapper mapper;

    @PostMapping
    @Operation(summary = "Salvar", description = "Cadastrar nova Documento Tipo Propriedade Intelectual")
    @ApiResponses({
            @ApiResponse(responseCode = "201", description = "Cadastrado com sucesso!"),
            @ApiResponse(responseCode = "422", description = "Erro de validação!"),
    })
    public ResponseEntity<Object> save(@RequestBody @Valid IpTypesDocumentRequestDTO dto) {
        IpTypeDocument ipTypeDocument = mapper.toEntity(dto);
        service.save(ipTypeDocument);
        URI location = generateHeaderLocation(ipTypeDocument.getId());
        return ResponseEntity.created(location).build();
    }

    @GetMapping
    @Operation(summary = "Obter", description = "Obter todos os Documentos propriedades intelectuais")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Sucesso na busca!"),
    })
    public ResponseEntity<List<IpTypesDocumentResponseDTO>> getAllIpTypesDocuments(){
        List<IpTypeDocument> result = service.getIpTypeDocument();
        List<IpTypesDocumentResponseDTO> list = result.stream().map(mapper::toDTO).toList();
        return ResponseEntity.ok(list);
    }

}
