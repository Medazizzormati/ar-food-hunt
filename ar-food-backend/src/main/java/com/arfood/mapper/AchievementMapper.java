package com.arfood.mapper;

import com.arfood.dto.AchievementDto;
import com.arfood.entity.Achievement;
import org.springframework.stereotype.Component;

@Component
public class AchievementMapper {
    
    public AchievementDto toDto(Achievement achievement) {
        return AchievementDto.builder()
                .id(achievement.getId())
                .title(achievement.getTitle())
                .description(achievement.getDescription())
                .icon(achievement.getIcon())
                .xpReward(achievement.getXpReward())
                .build();
    }
    
    public Achievement toEntity(AchievementDto achievementDto) {
        return Achievement.builder()
                .id(achievementDto.getId())
                .title(achievementDto.getTitle())
                .description(achievementDto.getDescription())
                .icon(achievementDto.getIcon())
                .xpReward(achievementDto.getXpReward())
                .build();
    }
    
    public void updateEntityFromDto(AchievementDto achievementDto, Achievement achievement) {
        if (achievementDto.getTitle() != null) achievement.setTitle(achievementDto.getTitle());
        if (achievementDto.getDescription() != null) achievement.setDescription(achievementDto.getDescription());
        if (achievementDto.getIcon() != null) achievement.setIcon(achievementDto.getIcon());
        if (achievementDto.getXpReward() != null) achievement.setXpReward(achievementDto.getXpReward());
    }
}
