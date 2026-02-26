package com.nitssrpi.NIT_SRPI.controller;

import com.nitssrpi.NIT_SRPI.service.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("api/auth/")
@CrossOrigin(origins = "*")
public class AuthController {
    @Autowired // <--- ESSA ANOTAÇÃO É OBRIGATÓRIA
    private AuthService authService;

    // Rota para o Flutter pedir o envio do e-mail
    @PostMapping("/forgot-password")
    public ResponseEntity<?> forgotPassword(@RequestBody Map<String, String> body) {
        String email = body.get("email");
        authService.initiatePasswordReset(email);
        return ResponseEntity.ok().body("{\"message\": \"Se o e-mail existir, o código foi enviado.\"}");
    }

    // Rota para o Flutter enviar o código + a nova senha
    @PostMapping("/reset-password")
    public ResponseEntity<?> resetPassword(@RequestBody Map<String, String> body) {
        String token = body.get("token");
        String newPassword = body.get("newPassword");

        try {
            authService.updatePassword(token, newPassword);
            return ResponseEntity.ok().body("{\"message\": \"Senha atualizada com sucesso!\"}");
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }

}
