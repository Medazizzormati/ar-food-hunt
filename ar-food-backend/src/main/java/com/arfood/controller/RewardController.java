package com.arfood.controller;

import com.arfood.annotation.Auditable;
import com.arfood.dto.RewardDto;
import com.arfood.entity.Reward;
import com.arfood.exception.ResourceNotFoundException;
import com.arfood.mapper.RewardMapper;
import com.arfood.service.RewardService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/rewards")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class RewardController {
    
    private final RewardService rewardService;
    private final RewardMapper rewardMapper;
    
    @GetMapping
    @Auditable
    public ResponseEntity<List<RewardDto>> getAllRewards() {
        List<Reward> rewards = rewardService.getAllRewards();
        List<RewardDto> rewardDtos = rewards.stream()
                .map(rewardMapper::toDto)
                .collect(Collectors.toList());
        return ResponseEntity.ok(rewardDtos);
    }
    
    @GetMapping("/user/{userId}")
    @Auditable
    public ResponseEntity<List<RewardDto>> getRewardsByUserId(@PathVariable Long userId) {
        List<Reward> rewards = rewardService.getRewardsByUserId(userId);
        List<RewardDto> rewardDtos = rewards.stream()
                .map(rewardMapper::toDto)
                .collect(Collectors.toList());
        return ResponseEntity.ok(rewardDtos);
    }
    
    @GetMapping("/{id}")
    @Auditable
    public ResponseEntity<RewardDto> getRewardById(@PathVariable Long id) {
        Reward reward = rewardService.getRewardById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Reward", id));
        return ResponseEntity.ok(rewardMapper.toDto(reward));
    }
    
    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    @Auditable
    public ResponseEntity<RewardDto> createReward(@Valid @RequestBody RewardDto rewardDto) {
        Reward reward = rewardMapper.toEntity(rewardDto);
        Reward createdReward = rewardService.createReward(reward);
        return ResponseEntity.ok(rewardMapper.toDto(createdReward));
    }
    
    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Auditable
    public ResponseEntity<RewardDto> updateReward(@PathVariable Long id, @Valid @RequestBody RewardDto rewardDto) {
        Reward existingReward = rewardService.getRewardById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Reward", id));
        
        rewardMapper.updateEntityFromDto(rewardDto, existingReward);
        Reward updatedReward = rewardService.updateReward(id, existingReward);
        
        return ResponseEntity.ok(rewardMapper.toDto(updatedReward));
    }
    
    @PostMapping("/{id}/redeem")
    @Auditable
    public ResponseEntity<RewardDto> redeemReward(@PathVariable Long id) {
        Reward reward = rewardService.redeemReward(id);
        return ResponseEntity.ok(rewardMapper.toDto(reward));
    }
    
    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Auditable
    public ResponseEntity<Void> deleteReward(@PathVariable Long id) {
        rewardService.deleteReward(id);
        return ResponseEntity.noContent().build();
    }
}
