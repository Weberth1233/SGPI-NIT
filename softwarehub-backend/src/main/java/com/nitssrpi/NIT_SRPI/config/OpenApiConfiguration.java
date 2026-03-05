package com.nitssrpi.NIT_SRPI.config;

import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.info.Contact;
import io.swagger.v3.oas.annotations.info.Info;
import org.springframework.context.annotation.Configuration;

@Configuration
@OpenAPIDefinition(
        info = @Info(
                title = "SofwareHub API",
                version = "v1",
                contact = @Contact(name ="Weberth Erik Anolar Sirqueira", email = "weberth.ea@unitins.br")
        )
)
public class OpenApiConfiguration {
}
