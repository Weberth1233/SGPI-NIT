package com.nitssrpi.NIT_SRPI.service;
import com.nitssrpi.NIT_SRPI.Infra.security.SecurityService;
import com.nitssrpi.NIT_SRPI.model.User;
import com.nitssrpi.NIT_SRPI.repository.UserRepository;
import com.nitssrpi.NIT_SRPI.repository.specs.UserSpecs;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
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
//        if(user.getRole() == null){
//            user.setRole("USER");
//        }
        return repository.save(user);
    }

//    public Optional<User> getLoggedUserData() {
//        Authentication authentication =
//                SecurityContextHolder.getContext().getAuthentication();
//
//        if (authentication == null || !authentication.isAuthenticated()) {
//            return Optional.empty();
//        }
//
//        String email = authentication.getName();
//
//        return repository.findByEmail(email);
//    }

    public User getLoggedUser() {
        Authentication authentication =
                SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || !authentication.isAuthenticated()) {
            throw new RuntimeException("Usuário não autenticado");
        }

        return (User) authentication.getPrincipal();
    }

    public Optional<User> getUserById(Long id){
        return repository.findById(id);
    }

    public Page<User> searchUsers(String username, String fullName, Integer page, Integer pageSize){
        Specification<User> specs = Specification.where((root, query, cb) -> cb.conjunction());
        if(username != null){
            specs = specs.and(UserSpecs.likeUserName(username));
        }
        if(fullName != null){
            specs = specs.and(UserSpecs.likeFullName(fullName));
        }
        Pageable pageRequest = PageRequest.of(page, pageSize);
        return repository.findAll(specs, pageRequest);
    }

    public UserDetails findByEmail(String email){
        return repository.findByEmail(email);
    }

    public void update(User user){
        if(user.getId() == null){
            throw new IllegalArgumentException("Para atualizar é necessário que o usuário esteja cadastrado!");
        }
//        if(user.getRole() == null){
//            user.setRole("USER");
//        }
        repository.save(user);
    }
}
