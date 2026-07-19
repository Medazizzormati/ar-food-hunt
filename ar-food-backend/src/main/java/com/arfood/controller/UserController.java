package com.arfood.controller;

import com.arfood.annotation.Auditable;
import com.arfood.dto.UserDto;
import com.arfood.entity.User;
import com.arfood.exception.ResourceNotFoundException;
import com.arfood.mapper.UserMapper;
import com.arfood.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class UserController {
    
    private final UserService userService;
    private final UserMapper userMapper;
    
    @GetMapping
    @PreAuthorize("hasRole('ADMIN')")
    @Auditable
    public ResponseEntity<List<UserDto>> getAllUsers() {
        List<User> users = userService.getAllUsers();
        List<UserDto> userDtos = users.stream()
                .map(userMapper::toDto)
                .collect(Collectors.toList());
        return ResponseEntity.ok(userDtos);
    }
    
    @GetMapping("/{id}")
    @Auditable
    public ResponseEntity<UserDto> getUserById(@PathVariable Long id) {
        User user = userService.getUserById(id)
                .orElseThrow(() -> new ResourceNotFoundException("User", id));
        return ResponseEntity.ok(userMapper.toDto(user));
    }
    
    @PutMapping("/{id}")
    @Auditable
    public ResponseEntity<UserDto> updateUser(@PathVariable Long id, @Valid @RequestBody UserDto userDto) {
        User existingUser = userService.getUserById(id)
                .orElseThrow(() -> new ResourceNotFoundException("User", id));
        
        userMapper.updateEntityFromDto(userDto, existingUser);
        User updatedUser = userService.updateUser(id, existingUser);
        
        return ResponseEntity.ok(userMapper.toDto(updatedUser));
    }
    
    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Auditable
    public ResponseEntity<Void> deleteUser(@PathVariable Long id) {
        userService.deleteUser(id);
        return ResponseEntity.noContent().build();
    }
    
    @PostMapping("/{id}/coins")
    @Auditable
    public ResponseEntity<UserDto> addCoins(@PathVariable Long id, @RequestParam Integer coins) {
        User user = userService.addCoins(id, coins);
        return ResponseEntity.ok(userMapper.toDto(user));
    }
    
    @PostMapping("/{id}/xp")
    @Auditable
    public ResponseEntity<UserDto> addXP(@PathVariable Long id, @RequestParam Integer xp) {
        User user = userService.addXP(id, xp);
        return ResponseEntity.ok(userMapper.toDto(user));
    }
}
