package com.arfood.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FoodTruckDto {
    private Long id;
    
    @NotBlank(message = "Name is required")
    @Size(max = 100, message = "Name must not exceed 100 characters")
    private String name;
    
    @Size(max = 50, message = "Category must not exceed 50 characters")
    private String category;
    
    private Double latitude;
    
    private Double longitude;
    
    @Size(max = 1000, message = "Description must not exceed 1000 characters")
    private String description;
}
