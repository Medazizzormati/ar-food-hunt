package com.arfood.mapper;

import com.arfood.dto.FoodTruckDto;
import com.arfood.entity.FoodTruck;
import org.springframework.stereotype.Component;

@Component
public class FoodTruckMapper {
    
    public FoodTruckDto toDto(FoodTruck foodTruck) {
        return FoodTruckDto.builder()
                .id(foodTruck.getId())
                .name(foodTruck.getName())
                .category(foodTruck.getCategory())
                .latitude(foodTruck.getLatitude())
                .longitude(foodTruck.getLongitude())
                .description(foodTruck.getDescription())
                .build();
    }
    
    public FoodTruck toEntity(FoodTruckDto foodTruckDto) {
        return FoodTruck.builder()
                .id(foodTruckDto.getId())
                .name(foodTruckDto.getName())
                .category(foodTruckDto.getCategory())
                .latitude(foodTruckDto.getLatitude())
                .longitude(foodTruckDto.getLongitude())
                .description(foodTruckDto.getDescription())
                .build();
    }
    
    public void updateEntityFromDto(FoodTruckDto foodTruckDto, FoodTruck foodTruck) {
        if (foodTruckDto.getName() != null) foodTruck.setName(foodTruckDto.getName());
        if (foodTruckDto.getCategory() != null) foodTruck.setCategory(foodTruckDto.getCategory());
        if (foodTruckDto.getLatitude() != null) foodTruck.setLatitude(foodTruckDto.getLatitude());
        if (foodTruckDto.getLongitude() != null) foodTruck.setLongitude(foodTruckDto.getLongitude());
        if (foodTruckDto.getDescription() != null) foodTruck.setDescription(foodTruckDto.getDescription());
    }
}
