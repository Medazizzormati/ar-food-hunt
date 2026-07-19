package com.arfood.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "audit_logs")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AuditLog {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String username;
    
    private String action;
    
    private String resource;
    
    private String details;
    
    private String ipAddress;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();
}
