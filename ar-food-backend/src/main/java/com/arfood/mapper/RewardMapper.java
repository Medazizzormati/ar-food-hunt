package com.arfood.mapper;

import com.arfood.dto.RewardDto;
import com.arfood.entity.Reward;
import org.springframework.stereotype.Component;

@Component
public class RewardMapper {
    
    public RewardDto toDto(Reward reward) {
        return RewardDto.builder()
                .id(reward.getId())
                .title(reward.getTitle())
                .type(reward.getType())
                .value(reward.getValue())
                .userId(reward.getUser() != null ? reward.getUser().getId() : null)
                .eventId(reward.getEvent() != null ? reward.getEvent().getId() : null)
                .build();
    }
    
    public Reward toEntity(RewardDto rewardDto) {
        return Reward.builder()
                .id(rewardDto.getId())
                .title(rewardDto.getTitle())
                .type(rewardDto.getType())
                .value(rewardDto.getValue())
                .build();
    }
    
    public void updateEntityFromDto(RewardDto rewardDto, Reward reward) {
        if (rewardDto.getTitle() != null) reward.setTitle(rewardDto.getTitle());
        if (rewardDto.getType() != null) reward.setType(rewardDto.getType());
        if (rewardDto.getValue() != null) reward.setValue(rewardDto.getValue());
    }
}
