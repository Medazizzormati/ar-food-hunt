package com.arfood.service;

import com.arfood.entity.Achievement;
import com.arfood.entity.User;
import com.arfood.repository.AchievementRepository;
import com.arfood.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class AchievementService {
    
    private final AchievementRepository achievementRepository;
    private final UserRepository userRepository;
    
    public List<Achievement> getAllAchievements() {
        return achievementRepository.findAll();
    }
    
    public Optional<Achievement> getAchievementById(Long id) {
        return achievementRepository.findById(id);
    }
    
    public Achievement createAchievement(Achievement achievement) {
        return achievementRepository.save(achievement);
    }
    
    public Achievement updateAchievement(Long id, Achievement achievementDetails) {
        Achievement achievement = achievementRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Achievement not found"));
        
        achievement.setTitle(achievementDetails.getTitle());
        achievement.setDescription(achievementDetails.getDescription());
        achievement.setIcon(achievementDetails.getIcon());
        achievement.setXpReward(achievementDetails.getXpReward());
        
        return achievementRepository.save(achievement);
    }
    
    public void deleteAchievement(Long id) {
        achievementRepository.deleteById(id);
    }
    
    public Achievement unlockAchievement(Long achievementId, Long userId) {
        Achievement achievement = achievementRepository.findById(achievementId)
                .orElseThrow(() -> new RuntimeException("Achievement not found"));
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        achievement.unlock(user);
        userRepository.save(user);
        return achievementRepository.save(achievement);
    }
}
