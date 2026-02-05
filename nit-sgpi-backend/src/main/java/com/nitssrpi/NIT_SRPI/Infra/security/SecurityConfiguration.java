package com.nitssrpi.NIT_SRPI.Infra.security;

import org.apache.tomcat.util.net.openssl.ciphers.Authentication;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
//hABILITA O WEB SECURITY E EU VOU CONFIGURAR DENTRO DESSA CLASSE
@EnableWebSecurity
public class SecurityConfiguration {

    @Autowired
    SecurityFilter securityFilter;

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity httpSecurity) throws Exception {
        return  httpSecurity
                .csrf(AbstractHttpConfigurer::disable)
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(authorize -> authorize
                        .requestMatchers(HttpMethod.POST, "/auth/login").permitAll()
                        .requestMatchers(HttpMethod.POST, "/auth/register").permitAll()

                        // IpTypes - ROLES
                        .requestMatchers(HttpMethod.GET, "/ip_types/**").hasAnyRole("ADMIN", "USER")
                        .requestMatchers(HttpMethod.POST, "/ip_types/**").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.PUT, "/ip_types/**").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.DELETE, "/ip_types/**").hasRole("ADMIN")

                        // Process - ROLES
                        .requestMatchers(HttpMethod.GET, "/process/**").hasAnyRole("ADMIN", "USER")
                        .requestMatchers(HttpMethod.POST, "/process/**").hasAnyRole("ADMIN", "USER")
                        .requestMatchers(HttpMethod.PUT, "/process/**").hasAnyRole("ADMIN", "USER")
                        .requestMatchers(HttpMethod.DELETE, "/process/**").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.GET, "/attachments/type/**").hasAnyAuthority("ADMIN", "USER", "ROLE_ADMIN", "ROLE_USER")



                        .anyRequest().authenticated()
                )
                .addFilterBefore(securityFilter, UsernamePasswordAuthenticationFilter.class)
                .build();
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration authenticationConfiguration) throws Exception{
        return authenticationConfiguration.getAuthenticationManager();
    }

    @Bean
    public PasswordEncoder passwordEncoder(){
        return new BCryptPasswordEncoder();
    }
}
