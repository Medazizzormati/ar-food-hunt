package com.arfood.mapper;

import com.arfood.dto.CollectionDto;
import com.arfood.entity.Collection;
import org.springframework.stereotype.Component;

@Component
public class CollectionMapper {
    
    public CollectionDto toDto(Collection collection) {
        return CollectionDto.builder()
                .id(collection.getId())
                .title(collection.getTitle())
                .rewardXP(collection.getRewardXP())
                .rewardCoins(collection.getRewardCoins())
                .eventId(collection.getEvent() != null ? collection.getEvent().getId() : null)
                .build();
    }
    
    public Collection toEntity(CollectionDto collectionDto) {
        return Collection.builder()
                .id(collectionDto.getId())
                .title(collectionDto.getTitle())
                .rewardXP(collectionDto.getRewardXP())
                .rewardCoins(collectionDto.getRewardCoins())
                .build();
    }
    
    public void updateEntityFromDto(CollectionDto collectionDto, Collection collection) {
        if (collectionDto.getTitle() != null) collection.setTitle(collectionDto.getTitle());
        if (collectionDto.getRewardXP() != null) collection.setRewardXP(collectionDto.getRewardXP());
        if (collectionDto.getRewardCoins() != null) collection.setRewardCoins(collectionDto.getRewardCoins());
    }
}
