package com.nitssrpi.NIT_SRPI.model;
import io.hypersistence.utils.hibernate.type.json.JsonType;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.Type;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.util.List;

@Entity
@Table(name = "ip_types", schema = "public")
@Getter
@Setter
@EntityListeners(AuditingEntityListener.class)
public class IpTypes {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    @Type(JsonType.class)
    @Column(columnDefinition = "jsonb")
    private FormStructure formStructure;
    // Ex: Software exige "Termo de Cessão" e "Declaração de Veracidade".
    @OneToMany(mappedBy = "ipType", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<IpTypeDocument> requiredDocuments;
}
