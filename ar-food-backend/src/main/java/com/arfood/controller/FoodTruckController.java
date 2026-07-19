package com.arfood.controller;

import com.arfood.annotation.Auditable;
import com.arfood.dto.FoodTruckDto;
import com.arfood.entity.FoodTruck;
import com.arfood.exception.ResourceNotFoundException;
import com.arfood.mapper.FoodTruckMapper;
import com.arfood.service.FoodTruckService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/foodtrucks")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class FoodTruckController {
    
    private final FoodTruckService foodTruckService;
    private final FoodTruckMapper foodTruckMapper;
    
    @GetMapping
    @Auditable
    public ResponseEntity<List<FoodTruckDto>> getAllFoodTrucks() {
        List<FoodTruck> foodTrucks = foodTruckService.getAllFoodTrucks();
        List<FoodTruckDto> foodTruckDtos = foodTrucks.stream()
                .map(foodTruckMapper::toDto)
                .collect(Collectors.toList());
        return ResponseEntity.ok(foodTruckDtos);
    }
    
    @GetMapping("/category/{category}")
    @Auditable
    public ResponseEntity<List<FoodTruckDto>> getFoodTrucksByCategory(@PathVariable String category) {
        List<FoodTruck> foodTrucks = foodTruckService.getFoodTrucksByCategory(category);
        List<FoodTruckDto> foodTruckDtos = foodTrucks.stream()
                .map(foodTruckMapper::toDto)
                .collect(Collectors.toList());
        return ResponseEntity.ok(foodTruckDtos);
    }
    
    @GetMapping("/{id}")
    @Auditable
    public ResponseEntity<FoodTruckDto> getFoodTruckById(@PathVariable Long id) {
        FoodTruck foodTruck = foodTruckService.getFoodTruckById(id)
                .orElseThrow(() -> new ResourceNotFoundException("FoodTruck", id));
        return ResponseEntity.ok(foodTruckMapper.toDto(foodTruck));
    }
    
    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    @Auditable
    public ResponseEntity<FoodTruckDto> createFoodTruck(@Valid @RequestBody FoodTruckDto foodTruckDto) {
        FoodTruck foodTruck = foodTruckMapper.toEntity(foodTruckDto);
        FoodTruck createdFoodTruck = foodTruckService.createFoodTruck(foodTruck);
        return ResponseEntity.ok(foodTruckMapper.toDto(createdFoodTruck));
    }
    
    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Auditable
    public ResponseEntity<FoodTruckDto> updateFoodTruck(@PathVariable Long id, @Valid @RequestBody FoodTruckDto foodTruckDto) {
        FoodTruck existingFoodTruck = foodTruckService.getFoodTruckById(id)
                .orElseThrow(() -> new ResourceNotFoundException("FoodTruck", id));
        
        foodTruckMapper.updateEntityFromDto(foodTruckDto, existingFoodTruck);
        FoodTruck updatedFoodTruck = foodTruckService.updateFoodTruck(id, existingFoodTruck);
        
        return ResponseEntity.ok(foodTruckMapper.toDto(updatedFoodTruck));
    }
    
    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Auditable
    public ResponseEntity<Void> deleteFoodTruck(@PathVariable Long id) {
        foodTruckService.deleteFoodTruck(id);
        return ResponseEntity.noContent().build();
    }
}
