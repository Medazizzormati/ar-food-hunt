package com.arfood.dto;

import com.arfood.enums.CollectibleType;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CollectibleDto {
    private Long id;
    
    @NotBlank(message = "Name is required")
    @Size(max = 100, message = "Name must not exceed 100 characters")
    private String name;
    
    private String model3D;
    
    @NotNull(message = "Type is required")
    private CollectibleType type;
    
    @Positive(message = "XP reward must be positive")
    private Integer xpReward;
    
    @Positive(message = "Coin reward must be positive")
    private Integer coinReward;
    
    private Double latitude;
    
    private Double longitude;
    
    private Boolean available;
    
    private Long foodTruckId;
}
