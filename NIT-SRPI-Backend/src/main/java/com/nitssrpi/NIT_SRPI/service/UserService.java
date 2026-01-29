package com.nitssrpi.NIT_SRPI.service;

import com.nitssrpi.NIT_SRPI.model.User;
import com.nitssrpi.NIT_SRPI.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class UserService {
    private final UserRepository repository;

    @Transactional
    public User save(User user){
        if(user.getAddress() != null){
            //Diz para o endereço quem é o dono dele
            user.getAddress().setUser(user);
        }
        //Todos os usuarios cadastrados vão iniciar com a Role USER
        if(user.getRole() == null){
            user.setRole("USER");
        }
        return repository.save(user);
    }

    public Optional<User> getUserById(Long id){
        return repository.findById(id);
    }

    public void update(User user){
        if(user.getId() == null){
            throw new IllegalArgumentException("Para atualizar é necessário que o usuário esteja cadastrado!");
        }
        if(user.getRole() == null){
            user.setRole("USER");
        }
        repository.save(user);
    }
}
