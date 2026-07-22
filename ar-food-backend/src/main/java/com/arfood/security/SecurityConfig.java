package com.arfood.security;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.Arrays;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
@RequiredArgsConstructor
public class SecurityConfig {
    
    private final JwtAuthenticationFilter jwtAuthenticationFilter;
    private final UserDetailsServiceImpl userDetailsService;
    private final RateLimitingFilter rateLimitingFilter;
    
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .cors(cors -> cors.configurationSource(corsConfigurationSource()))
                .csrf(csrf -> csrf.disable())
                .authorizeHttpRequests(auth -> auth
                        // Public endpoints
                        .requestMatchers("/api/auth/**").permitAll()
                        .requestMatchers("/api/actuator/**").permitAll()
                        
                        // Read-only endpoints for all authenticated users
                        .requestMatchers(HttpMethod.GET, "/api/events/**").hasAnyRole("USER", "MODERATOR", "ADMIN")
                        .requestMatchers(HttpMethod.GET, "/api/achievements/**").hasAnyRole("USER", "MODERATOR", "ADMIN")
                        .requestMatchers(HttpMethod.GET, "/api/collections/**").hasAnyRole("USER", "MODERATOR", "ADMIN")
                        .requestMatchers(HttpMethod.GET, "/api/foodtrucks/**").hasAnyRole("USER", "MODERATOR", "ADMIN")
                        .requestMatchers(HttpMethod.GET, "/api/collectibles/**").hasAnyRole("USER", "MODERATOR", "ADMIN")
                        .requestMatchers(HttpMethod.GET, "/api/rewards/**").hasAnyRole("USER", "MODERATOR", "ADMIN")
                        
                        // User-specific actions
                        .requestMatchers(HttpMethod.POST, "/api/collectibles/*/collect/**").hasAnyRole("USER", "MODERATOR", "ADMIN")
                        .requestMatchers(HttpMethod.POST, "/api/collections/*/complete/**").hasAnyRole("USER", "MODERATOR", "ADMIN")
                        .requestMatchers(HttpMethod.POST, "/api/achievements/*/unlock/**").hasAnyRole("USER", "MODERATOR", "ADMIN")
                        .requestMatchers(HttpMethod.POST, "/api/rewards/*/redeem").hasAnyRole("USER", "MODERATOR", "ADMIN")
                        
                        // Moderator and Admin endpoints
                        .requestMatchers(HttpMethod.POST, "/api/events/**").hasAnyRole("MODERATOR", "ADMIN")
                        .requestMatchers(HttpMethod.PUT, "/api/events/**").hasAnyRole("MODERATOR", "ADMIN")
                        .requestMatchers(HttpMethod.DELETE, "/api/events/**").hasAnyRole("MODERATOR", "ADMIN")
                        .requestMatchers(HttpMethod.POST, "/api/events/*/activate").hasAnyRole("MODERATOR", "ADMIN")
                        .requestMatchers(HttpMethod.POST, "/api/events/*/deactivate").hasAnyRole("MODERATOR", "ADMIN")
                        
                        // User-specific endpoints (users can access their own data)
                        .requestMatchers(HttpMethod.GET, "/api/users/**").hasAnyRole("USER", "MODERATOR", "ADMIN")
                        .requestMatchers(HttpMethod.PUT, "/api/users/**").hasAnyRole("USER", "MODERATOR", "ADMIN")
                        .requestMatchers(HttpMethod.POST, "/api/users/*/coins").hasAnyRole("USER", "MODERATOR", "ADMIN")
                        .requestMatchers(HttpMethod.POST, "/api/users/*/xp").hasAnyRole("USER", "MODERATOR", "ADMIN")
                        
                        // Admin-only user management
                        .requestMatchers(HttpMethod.DELETE, "/api/users/**").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.POST, "/api/achievements/**").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.PUT, "/api/achievements/**").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.DELETE, "/api/achievements/**").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.POST, "/api/rewards/**").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.PUT, "/api/rewards/**").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.DELETE, "/api/rewards/**").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.POST, "/api/collections/**").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.PUT, "/api/collections/**").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.DELETE, "/api/collections/**").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.POST, "/api/foodtrucks/**").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.PUT, "/api/foodtrucks/**").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.DELETE, "/api/foodtrucks/**").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.POST, "/api/collectibles/**").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.PUT, "/api/collectibles/**").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.DELETE, "/api/collectibles/**").hasRole("ADMIN")
                        .requestMatchers("/api/audit/**").hasRole("ADMIN")
                        
                        // Default: require authentication
                        .anyRequest().authenticated()
                )
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authenticationProvider(authenticationProvider())
                .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class)
                .addFilterBefore(rateLimitingFilter, UsernamePasswordAuthenticationFilter.class);
        
        return http.build();
    }
    
    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.setAllowedOrigins(Arrays.asList("*"));
        configuration.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE", "OPTIONS"));
        configuration.setAllowedHeaders(Arrays.asList("*"));
        configuration.setAllowCredentials(true);
        
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }
    
    @Bean
    public AuthenticationProvider authenticationProvider() {
        DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
        authProvider.setUserDetailsService(userDetailsService);
        authProvider.setPasswordEncoder(passwordEncoder());
        return authProvider;
    }
    
    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }
    
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
