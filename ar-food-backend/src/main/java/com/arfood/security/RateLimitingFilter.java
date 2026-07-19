package com.arfood.security;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

@Component
public class RateLimitingFilter extends OncePerRequestFilter {
    
    @Value("${rate.limit.requests:100}")
    private int rateLimit;
    
    @Value("${rate.limit.window:60000}")
    private long windowMillis;
    
    private final ConcurrentHashMap<String, RateLimiter> rateLimiters = new ConcurrentHashMap<>();
    
    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        
        String clientIp = getClientIp(request);
        String key = clientIp + ":" + request.getRequestURI();
        
        RateLimiter rateLimiter = rateLimiters.computeIfAbsent(key, k -> new RateLimiter(rateLimit, windowMillis));
        
        if (!rateLimiter.tryAcquire()) {
            response.setStatus(429);
            response.setContentType("application/json");
            response.getWriter().write("{\"error\":\"Too Many Requests\",\"message\":\"Rate limit exceeded\"}");
            return;
        }
        
        filterChain.doFilter(request, response);
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
    
    private static class RateLimiter {
        private final int maxRequests;
        private final long windowMillis;
        private final AtomicInteger counter;
        private long windowStart;
        
        public RateLimiter(int maxRequests, long windowMillis) {
            this.maxRequests = maxRequests;
            this.windowMillis = windowMillis;
            this.counter = new AtomicInteger(0);
            this.windowStart = System.currentTimeMillis();
        }
        
        public synchronized boolean tryAcquire() {
            long now = System.currentTimeMillis();
            
            if (now - windowStart > windowMillis) {
                counter.set(0);
                windowStart = now;
            }
            
            return counter.incrementAndGet() <= maxRequests;
        }
    }
}
