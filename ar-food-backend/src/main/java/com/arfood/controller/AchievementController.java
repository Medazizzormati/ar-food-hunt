package com.arfood.controller;

import com.arfood.annotation.Auditable;
import com.arfood.dto.AchievementDto;
import com.arfood.entity.Achievement;
import com.arfood.exception.ResourceNotFoundException;
import com.arfood.mapper.AchievementMapper;
import com.arfood.service.AchievementService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/achievements")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class AchievementController {
    
    private final AchievementService achievementService;
    private final AchievementMapper achievementMapper;
    
    @GetMapping
    @Auditable
    public ResponseEntity<List<AchievementDto>> getAllAchievements() {
        List<Achievement> achievements = achievementService.getAllAchievements();
        List<AchievementDto> achievementDtos = achievements.stream()
                .map(achievementMapper::toDto)
                .collect(Collectors.toList());
        return ResponseEntity.ok(achievementDtos);
    }
    
    @GetMapping("/{id}")
    @Auditable
    public ResponseEntity<AchievementDto> getAchievementById(@PathVariable Long id) {
        Achievement achievement = achievementService.getAchievementById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Achievement", id));
        return ResponseEntity.ok(achievementMapper.toDto(achievement));
    }
    
    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    @Auditable
    public ResponseEntity<AchievementDto> createAchievement(@Valid @RequestBody AchievementDto achievementDto) {
        Achievement achievement = achievementMapper.toEntity(achievementDto);
        Achievement createdAchievement = achievementService.createAchievement(achievement);
        return ResponseEntity.ok(achievementMapper.toDto(createdAchievement));
    }
    
    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Auditable
    public ResponseEntity<AchievementDto> updateAchievement(@PathVariable Long id, @Valid @RequestBody AchievementDto achievementDto) {
        Achievement existingAchievement = achievementService.getAchievementById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Achievement", id));
        
        achievementMapper.updateEntityFromDto(achievementDto, existingAchievement);
        Achievement updatedAchievement = achievementService.updateAchievement(id, existingAchievement);
        
        return ResponseEntity.ok(achievementMapper.toDto(updatedAchievement));
    }
    
    @PostMapping("/{achievementId}/unlock/{userId}")
    @Auditable
    public ResponseEntity<AchievementDto> unlockAchievement(@PathVariable Long achievementId, @PathVariable Long userId) {
        Achievement achievement = achievementService.unlockAchievement(achievementId, userId);
        return ResponseEntity.ok(achievementMapper.toDto(achievement));
    }
    
    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Auditable
    public ResponseEntity<Void> deleteAchievement(@PathVariable Long id) {
        achievementService.deleteAchievement(id);
        return ResponseEntity.noContent().build();
    }
}
