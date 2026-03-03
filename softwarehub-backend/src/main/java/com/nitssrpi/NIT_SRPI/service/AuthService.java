package com.nitssrpi.NIT_SRPI.service;
import com.nitssrpi.NIT_SRPI.model.PasswordResetToken;
import com.nitssrpi.NIT_SRPI.model.User;
import com.nitssrpi.NIT_SRPI.repository.TokenRepository;
import com.nitssrpi.NIT_SRPI.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.util.UUID;

@Service
public class AuthService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private TokenRepository tokenRepository;

    @Autowired
    private EmailService emailService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public void initiatePasswordReset(String email) {
        // Como seu repository retorna UserDetails, verificamos se não é nulo
        UserDetails userDetails = userRepository.findByEmail(email);

        if (userDetails != null) {
            // 1. Gerar um código curto e amigável (6 caracteres)
            String token = UUID.randomUUID().toString().substring(0, 6).toUpperCase();

            // 2. Precisamos da entidade User para salvar no PasswordResetToken.
            // Se a sua classe User implementa UserDetails, fazemos um cast:
            User user = (User) userDetails;

            // 3. Limpar tokens antigos desse usuário para evitar lixo no banco
            tokenRepository.deleteByUser(user);

            // 4. Salvar o novo token com expiração de 15 minutos
            PasswordResetToken resetToken = new PasswordResetToken();
            resetToken.setToken(token);
            resetToken.setUser(user);
            resetToken.setExpiryDate(LocalDateTime.now().plusMinutes(15));
            tokenRepository.save(resetToken);

            // 5. Enviar o e-mail (usando seu e-mail verificado: weberth.ea@unitins.br)
            emailService.sendResetEmail(user.getEmail(), token);
        }
    }

    @Transactional
    public void updatePassword(String token, String newPassword) {
        // 1. Busca o token e valida existência
        PasswordResetToken resetToken = tokenRepository.findByToken(token)
                .orElseThrow(() -> new RuntimeException("Código inválido ou inexistente."));

        // 2. Verifica expiração
        if (resetToken.isExpired()) {
            tokenRepository.delete(resetToken);
            throw new RuntimeException("O código expirou. Solicite um novo.");
        }

        // 3. Atualiza a senha do usuário associado
        User user = resetToken.getUser();
        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);

        // 4. Deleta o token após o uso (Token de uso único)
        tokenRepository.delete(resetToken);
    }
}