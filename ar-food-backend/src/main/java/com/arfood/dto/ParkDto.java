package com.arfood.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ParkDto {
    private Long id;
    
    @NotBlank(message = "Park name is required")
    private String name;
    
    @NotBlank(message = "Location is required")
    private String location;
    
    private String description;
    private Double latitude;
    private Double longitude;
    private String imageUrl;
    
    @NotNull(message = "Active status is required")
    private Boolean active = true;
}
