package com.arfood.mapper;

import com.arfood.dto.CollectibleDto;
import com.arfood.entity.Collectible;
import org.springframework.stereotype.Component;

@Component
public class CollectibleMapper {
    
    public CollectibleDto toDto(Collectible collectible) {
        return CollectibleDto.builder()
                .id(collectible.getId())
                .name(collectible.getName())
                .model3D(collectible.getModel3D())
                .type(collectible.getType())
                .xpReward(collectible.getXpReward())
                .coinReward(collectible.getCoinReward())
                .latitude(collectible.getLatitude())
                .longitude(collectible.getLongitude())
                .available(collectible.getAvailable())
                .foodTruckId(collectible.getFoodTruck() != null ? collectible.getFoodTruck().getId() : null)
                .build();
    }
    
    public Collectible toEntity(CollectibleDto collectibleDto) {
        return Collectible.builder()
                .id(collectibleDto.getId())
                .name(collectibleDto.getName())
                .model3D(collectibleDto.getModel3D())
                .type(collectibleDto.getType())
                .xpReward(collectibleDto.getXpReward())
                .coinReward(collectibleDto.getCoinReward())
                .latitude(collectibleDto.getLatitude())
                .longitude(collectibleDto.getLongitude())
                .available(collectibleDto.getAvailable() != null ? collectibleDto.getAvailable() : true)
                .build();
    }
    
    public void updateEntityFromDto(CollectibleDto collectibleDto, Collectible collectible) {
        if (collectibleDto.getName() != null) collectible.setName(collectibleDto.getName());
        if (collectibleDto.getModel3D() != null) collectible.setModel3D(collectibleDto.getModel3D());
        if (collectibleDto.getType() != null) collectible.setType(collectibleDto.getType());
        if (collectibleDto.getXpReward() != null) collectible.setXpReward(collectibleDto.getXpReward());
        if (collectibleDto.getCoinReward() != null) collectible.setCoinReward(collectibleDto.getCoinReward());
        if (collectibleDto.getLatitude() != null) collectible.setLatitude(collectibleDto.getLatitude());
        if (collectibleDto.getLongitude() != null) collectible.setLongitude(collectibleDto.getLongitude());
        if (collectibleDto.getAvailable() != null) collectible.setAvailable(collectibleDto.getAvailable());
    }
}
