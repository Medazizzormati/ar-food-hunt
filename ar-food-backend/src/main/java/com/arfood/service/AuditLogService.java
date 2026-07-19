package com.arfood.service;

import com.arfood.entity.AuditLog;
import com.arfood.repository.AuditLogRepository;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AuditLogService {
    
    private final AuditLogRepository auditLogRepository;
    
    public void logAction(String username, String action, String resource, String details, HttpServletRequest request) {
        AuditLog auditLog = AuditLog.builder()
                .username(username)
                .action(action)
                .resource(resource)
                .details(details)
                .ipAddress(getClientIp(request))
                .build();
        
        auditLogRepository.save(auditLog);
    }
    
    public List<AuditLog> getUserAuditLogs(String username) {
        return auditLogRepository.findByUsernameOrderByCreatedAtDesc(username);
    }
    
    public List<AuditLog> getAuditLogsByAction(String action) {
        return auditLogRepository.findByActionOrderByCreatedAtDesc(action);
    }
    
    private String getClientIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("X-Real-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        return ip;
    }
}
