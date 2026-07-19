package com.arfood.controller;

import com.arfood.annotation.Auditable;
import com.arfood.dto.CollectionDto;
import com.arfood.entity.Collection;
import com.arfood.exception.ResourceNotFoundException;
import com.arfood.mapper.CollectionMapper;
import com.arfood.service.CollectionService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/collections")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class CollectionController {
    
    private final CollectionService collectionService;
    private final CollectionMapper collectionMapper;
    
    @GetMapping
    @Auditable
    public ResponseEntity<List<CollectionDto>> getAllCollections() {
        List<Collection> collections = collectionService.getAllCollections();
        List<CollectionDto> collectionDtos = collections.stream()
                .map(collectionMapper::toDto)
                .collect(Collectors.toList());
        return ResponseEntity.ok(collectionDtos);
    }
    
    @GetMapping("/{id}")
    @Auditable
    public ResponseEntity<CollectionDto> getCollectionById(@PathVariable Long id) {
        Collection collection = collectionService.getCollectionById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Collection", id));
        return ResponseEntity.ok(collectionMapper.toDto(collection));
    }
    
    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    @Auditable
    public ResponseEntity<CollectionDto> createCollection(@Valid @RequestBody CollectionDto collectionDto) {
        Collection collection = collectionMapper.toEntity(collectionDto);
        Collection createdCollection = collectionService.createCollection(collection);
        return ResponseEntity.ok(collectionMapper.toDto(createdCollection));
    }
    
    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Auditable
    public ResponseEntity<CollectionDto> updateCollection(@PathVariable Long id, @Valid @RequestBody CollectionDto collectionDto) {
        Collection existingCollection = collectionService.getCollectionById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Collection", id));
        
        collectionMapper.updateEntityFromDto(collectionDto, existingCollection);
        Collection updatedCollection = collectionService.updateCollection(id, existingCollection);
        
        return ResponseEntity.ok(collectionMapper.toDto(updatedCollection));
    }
    
    @PostMapping("/{collectionId}/complete/{userId}")
    @Auditable
    public ResponseEntity<CollectionDto> completeCollection(@PathVariable Long collectionId, @PathVariable Long userId) {
        Collection collection = collectionService.completeCollection(collectionId, userId);
        return ResponseEntity.ok(collectionMapper.toDto(collection));
    }
    
    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Auditable
    public ResponseEntity<Void> deleteCollection(@PathVariable Long id) {
        collectionService.deleteCollection(id);
        return ResponseEntity.noContent().build();
    }
}
