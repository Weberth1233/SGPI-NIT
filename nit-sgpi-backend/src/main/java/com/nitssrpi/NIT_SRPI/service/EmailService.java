package com.nitssrpi.NIT_SRPI.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service // Esta anotação é obrigatória para o Spring reconhecê-la
public class EmailService {

    @Autowired
    private JavaMailSender mailSender;

    public void sendResetEmail(String to, String token) {
        SimpleMailMessage message = new SimpleMailMessage();

        // Use o e-mail que vimos no seu print do Brevo
        message.setFrom("weberth.ea@unitins.br");
        message.setTo(to);
        message.setSubject("Código de Recuperação de Senha");
        message.setText("Seu código de recuperação é: " + token);

        mailSender.send(message);
    }
}
