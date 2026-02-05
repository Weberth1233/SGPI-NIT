package com.nitssrpi.NIT_SRPI.controller.common;
import com.nitssrpi.NIT_SRPI.controller.dto.ErroCampo;
import com.nitssrpi.NIT_SRPI.controller.dto.ErrorResposta;
import jakarta.validation.constraints.Null;
import org.springframework.http.HttpStatus;
import org.springframework.security.authorization.AuthorizationDeniedException;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.nio.file.AccessDeniedException;
import java.util.List;

@RestControllerAdvice
public class GlobalExceptionHandler {
    @ExceptionHandler(MethodArgumentNotValidException.class)
    @ResponseStatus(HttpStatus.UNPROCESSABLE_ENTITY)
    public ErrorResposta hendleMethodArgumentNotValidException(MethodArgumentNotValidException e) {
        List<FieldError> fieldErrors = e.getFieldErrors();
        List<ErroCampo> listaErros = fieldErrors.
                stream().map(fe -> new ErroCampo(fe.getField(), fe.getDefaultMessage())).toList();
        return new ErrorResposta(HttpStatus.UNPROCESSABLE_ENTITY.value(), "Erro de validação!", listaErros);
    }

    //NullPointerException:
    @ExceptionHandler(NullPointerException.class)
    @ResponseStatus(HttpStatus.CONFLICT)
    public ErrorResposta hendleMethodNullPointException(NullPointerException e) {
        return new ErrorResposta(HttpStatus.CONFLICT.value(), e.getMessage(), List.of());
    }

    @ExceptionHandler(AuthorizationDeniedException.class)
    @ResponseStatus(HttpStatus.FORBIDDEN)
    public ErrorResposta handleAccessDenied(AuthorizationDeniedException e) {
        return new ErrorResposta(
                HttpStatus.FORBIDDEN.value(),
                "Você não tem permissão para acessar este recurso",
                null
        );
    }


//
//    @ExceptionHandler(RegistroDuplicadoException.class)
//    @ResponseStatus(HttpStatus.CONFLICT)
//    public ErrorResposta handleRegistroDuplicadoException(RegistroDuplicadoException e) {
//        return ErrorResposta.conflito(e.getMessage());
//    }
//
//    @ExceptionHandler(OperacaoNaoPermitidaException.class)
//    @ResponseStatus(HttpStatus.BAD_REQUEST)
//    public ErrorResposta handleOperacaoNaoPermitidaException(OperacaoNaoPermitidaException e) {
//        return ErrorResposta.respostaPadrao(e.getMessage());
//    }
//
//    @ExceptionHandler(CampoInvalidoException.class)
//    @ResponseStatus(HttpStatus.UNPROCESSABLE_ENTITY)
//    public ErrorResposta handleCampoInvalidoException(CampoInvalidoException e){
//        return new ErrorResposta
//                (HttpStatus.UNPROCESSABLE_ENTITY.value(),
//                        "Erro de validação!",
//                        List.of(new ErroCampo(e.getCampo(), e.getMessage())));
//
//    }
//
//    @ExceptionHandler(AccessDeniedException.class)
//    @ResponseStatus(HttpStatus.FORBIDDEN)
//    public ErrorResposta handleAccesDeniedException(AccessDeniedException e){
//        return new ErrorResposta(HttpStatus.FORBIDDEN.value(), "Acesso Negado.", List.of());
//    }

    @ExceptionHandler(RuntimeException.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public ErrorResposta handleErrosNaoTratados(RuntimeException e){
        System.out.println(e.getMessage());
        System.out.println(e);
        return new ErrorResposta(HttpStatus.INTERNAL_SERVER_ERROR.value(), "Ocorreu um erro inesperado. Entre em contato com a administração",List.of());
    }

}
