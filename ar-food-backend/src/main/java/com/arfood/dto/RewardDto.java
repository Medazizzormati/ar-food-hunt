package com.arfood.dto;

import com.arfood.enums.RewardType;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RewardDto {
    private Long id;
    
    @NotBlank(message = "Title is required")
    @Size(max = 100, message = "Title must not exceed 100 characters")
    private String title;
    
    @NotNull(message = "Type is required")
    private RewardType type;
    
    @Size(max = 500, message = "Value must not exceed 500 characters")
    private String value;
    
    private Long userId;
    
    private Long eventId;
}
