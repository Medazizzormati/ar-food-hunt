package com.arfood.mapper;

import com.arfood.dto.UserDto;
import com.arfood.entity.User;
import org.springframework.stereotype.Component;

@Component
public class UserMapper {
    
    public UserDto toDto(User user) {
        return UserDto.builder()
                .id(user.getId())
                .username(user.getUsername())
                .email(user.getEmail())
                .level(user.getLevel())
                .xp(user.getXp())
                .coins(user.getCoins())
                .avatar(user.getAvatar())
                .role(user.getRole())
                .build();
    }
    
    public User toEntity(UserDto userDto) {
        return User.builder()
                .id(userDto.getId())
                .username(userDto.getUsername())
                .email(userDto.getEmail())
                .password(userDto.getPassword())
                .level(userDto.getLevel() != null ? userDto.getLevel() : 1)
                .xp(userDto.getXp() != null ? userDto.getXp() : 0)
                .coins(userDto.getCoins() != null ? userDto.getCoins() : 0)
                .avatar(userDto.getAvatar())
                .role(userDto.getRole() != null ? userDto.getRole() : com.arfood.enums.Role.USER)
                .build();
    }
    
    public void updateEntityFromDto(UserDto userDto, User user) {
        if (userDto.getUsername() != null) user.setUsername(userDto.getUsername());
        if (userDto.getEmail() != null) user.setEmail(userDto.getEmail());
        if (userDto.getPassword() != null) user.setPassword(userDto.getPassword());
        if (userDto.getLevel() != null) user.setLevel(userDto.getLevel());
        if (userDto.getXp() != null) user.setXp(userDto.getXp());
        if (userDto.getCoins() != null) user.setCoins(userDto.getCoins());
        if (userDto.getAvatar() != null) user.setAvatar(userDto.getAvatar());
        if (userDto.getRole() != null) user.setRole(userDto.getRole());
    }
}
