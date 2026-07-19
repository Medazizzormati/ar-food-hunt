package com.arfood.controller;

import com.arfood.annotation.Auditable;
import com.arfood.dto.CollectibleDto;
import com.arfood.entity.Collectible;
import com.arfood.exception.ResourceNotFoundException;
import com.arfood.mapper.CollectibleMapper;
import com.arfood.service.CollectibleService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/collectibles")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class CollectibleController {
    
    private final CollectibleService collectibleService;
    private final CollectibleMapper collectibleMapper;
    
    @GetMapping
    @Auditable
    public ResponseEntity<List<CollectibleDto>> getAllCollectibles() {
        List<Collectible> collectibles = collectibleService.getAllCollectibles();
        List<CollectibleDto> collectibleDtos = collectibles.stream()
                .map(collectibleMapper::toDto)
                .collect(Collectors.toList());
        return ResponseEntity.ok(collectibleDtos);
    }
    
    @GetMapping("/available")
    @Auditable
    public ResponseEntity<List<CollectibleDto>> getAvailableCollectibles() {
        List<Collectible> collectibles = collectibleService.getAvailableCollectibles();
        List<CollectibleDto> collectibleDtos = collectibles.stream()
                .map(collectibleMapper::toDto)
                .collect(Collectors.toList());
        return ResponseEntity.ok(collectibleDtos);
    }
    
    @GetMapping("/foodtruck/{foodTruckId}")
    @Auditable
    public ResponseEntity<List<CollectibleDto>> getCollectiblesByFoodTruckId(@PathVariable Long foodTruckId) {
        List<Collectible> collectibles = collectibleService.getCollectiblesByFoodTruckId(foodTruckId);
        List<CollectibleDto> collectibleDtos = collectibles.stream()
                .map(collectibleMapper::toDto)
                .collect(Collectors.toList());
        return ResponseEntity.ok(collectibleDtos);
    }
    
    @GetMapping("/{id}")
    @Auditable
    public ResponseEntity<CollectibleDto> getCollectibleById(@PathVariable Long id) {
        Collectible collectible = collectibleService.getCollectibleById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Collectible", id));
        return ResponseEntity.ok(collectibleMapper.toDto(collectible));
    }
    
    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    @Auditable
    public ResponseEntity<CollectibleDto> createCollectible(@Valid @RequestBody CollectibleDto collectibleDto) {
        Collectible collectible = collectibleMapper.toEntity(collectibleDto);
        Collectible createdCollectible = collectibleService.createCollectible(collectible);
        return ResponseEntity.ok(collectibleMapper.toDto(createdCollectible));
    }
    
    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Auditable
    public ResponseEntity<CollectibleDto> updateCollectible(@PathVariable Long id, @Valid @RequestBody CollectibleDto collectibleDto) {
        Collectible existingCollectible = collectibleService.getCollectibleById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Collectible", id));
        
        collectibleMapper.updateEntityFromDto(collectibleDto, existingCollectible);
        Collectible updatedCollectible = collectibleService.updateCollectible(id, existingCollectible);
        
        return ResponseEntity.ok(collectibleMapper.toDto(updatedCollectible));
    }
    
    @PostMapping("/{collectibleId}/collect/{userId}")
    @Auditable
    public ResponseEntity<CollectibleDto> collectCollectible(@PathVariable Long collectibleId, @PathVariable Long userId) {
        Collectible collectible = collectibleService.collectCollectible(collectibleId, userId);
        return ResponseEntity.ok(collectibleMapper.toDto(collectible));
    }
    
    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Auditable
    public ResponseEntity<Void> deleteCollectible(@PathVariable Long id) {
        collectibleService.deleteCollectible(id);
        return ResponseEntity.noContent().build();
    }
}
