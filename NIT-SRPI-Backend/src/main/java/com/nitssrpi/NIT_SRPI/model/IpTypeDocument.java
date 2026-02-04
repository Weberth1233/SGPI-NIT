package com.nitssrpi.NIT_SRPI.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "ip_type_documents", schema = "public")
@Getter
@Setter
public class IpTypeDocument {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "display_name")
    private String displayName; // Ex: "Termo de Transferência de Tecnologia"

    @Column(name = "template_file_path")
    private String templateFilePath; // Ex: "templates/software/termo_cessao.pdf"

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ip_type_id")
    private IpTypes ipType;
}
