package com.nitssrpi.NIT_SRPI.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import javax.print.attribute.standard.MediaSize;

@Entity
@Table(name = "attachments", schema = "public")
@Getter
@Setter
public class Attachment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "display_name")
    private String displayName;
    @Column(name = "template_file_path")
    private String templateFilePath;
    @Column(name = "signed_file_path")
    private String signedFilePath;
    @Column(length = 50)
    private String status;
    //Muitos documentos PERTENCEM A UM UNICO PROCESSO
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "process_id", nullable = false)
    private Process process;
}
