package com.arfood.controller;

import com.arfood.dto.AuthResponse;
import com.arfood.dto.LoginRequest;
import com.arfood.dto.RegisterRequest;
import com.arfood.dto.UserDto;
import com.arfood.entity.User;
import com.arfood.exception.ResourceNotFoundException;
import com.arfood.mapper.UserMapper;
import com.arfood.security.JwtUtil;
import com.arfood.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class AuthController {
    
    private final AuthenticationManager authenticationManager;
    private final UserService userService;
    private final JwtUtil jwtUtil;
    private final UserMapper userMapper;
    
    @PostMapping("/register")
    public ResponseEntity<AuthResponse> register(@Valid @RequestBody RegisterRequest request) {
        User user = User.builder()
                .username(request.getUsername())
                .email(request.getEmail())
                .password(request.getPassword())
                .build();
        
        User createdUser = userService.createUser(user);
        String token = jwtUtil.generateToken(createdUser.getUsername());
        UserDto userDto = userMapper.toDto(createdUser);
        
        return ResponseEntity.ok(AuthResponse.builder()
                .token(token)
                .userId(createdUser.getId())
                .username(createdUser.getUsername())
                .email(createdUser.getEmail())
                .role(createdUser.getRole())
                .build());
    }
    
    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@Valid @RequestBody LoginRequest request) {
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.getUsername(), request.getPassword())
        );
        
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        String token = jwtUtil.generateToken(userDetails.getUsername());
        User user = userService.getUserByUsername(request.getUsername())
                .orElseThrow(() -> new ResourceNotFoundException("User", "username", request.getUsername()));
        
        return ResponseEntity.ok(AuthResponse.builder()
                .token(token)
                .userId(user.getId())
                .username(user.getUsername())
                .email(user.getEmail())
                .role(user.getRole())
                .build());
    }
}
