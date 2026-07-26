package com.arfood.mapper;

import com.arfood.dto.ParkDto;
import com.arfood.entity.Park;
import org.springframework.stereotype.Component;

@Component
public class ParkMapper {
    
    public ParkDto toDto(Park park) {
        ParkDto dto = new ParkDto();
        dto.setId(park.getId());
        dto.setName(park.getName());
        dto.setLocation(park.getLocation());
        dto.setDescription(park.getDescription());
        dto.setLatitude(park.getLatitude());
        dto.setLongitude(park.getLongitude());
        dto.setImageUrl(park.getImageUrl());
        dto.setActive(park.getActive());
        return dto;
    }
    
    public Park toEntity(ParkDto dto) {
        Park park = new Park();
        park.setName(dto.getName());
        park.setLocation(dto.getLocation());
        park.setDescription(dto.getDescription());
        park.setLatitude(dto.getLatitude());
        park.setLongitude(dto.getLongitude());
        park.setImageUrl(dto.getImageUrl());
        park.setActive(dto.getActive());
        return park;
    }
}
