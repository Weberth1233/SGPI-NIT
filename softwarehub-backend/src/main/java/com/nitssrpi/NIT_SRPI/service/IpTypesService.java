package com.nitssrpi.NIT_SRPI.service;

import com.nitssrpi.NIT_SRPI.model.IpTypes;
import com.nitssrpi.NIT_SRPI.repository.IpTypesRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class IpTypesService {
    private final IpTypesRepository repository;

    public IpTypes save(IpTypes ipTypes){
        return repository.save(ipTypes);
    }

    public void update(IpTypes ipTypes){
        if(ipTypes.getId() == null){
            throw new IllegalArgumentException("Para atualizar é necessário que o usuário esteja cadastrado!");
        }
        repository.save(ipTypes);
    }


    //ALL TYPES OF PROPERTY
     public List<IpTypes> allTypesOfProperty(){
        return repository.findAll();
     }

    public Optional<IpTypes> getById(Long id){
        return repository.findById(id);
    }

    public void delete(IpTypes ipTypes){
        repository.delete(ipTypes);
    }

}
