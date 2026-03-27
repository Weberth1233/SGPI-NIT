package com.nitssrpi.NIT_SRPI.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Entity
@Table(name = "external_authors")
@Getter
@Setter
public class ExternalAuthor {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "full_name", nullable = false)
    private String fullName;
    @Column(unique = true)
    private String cpf;
    private String email;
    @Column(name = "active")
    private boolean active;
    // O Usuário que "dono" deste cadastro provisório
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "owner_user_id", nullable = false)
    private User owner;

    @ManyToMany(mappedBy = "externalAuthors")
    private List<Process> processes;
}
