package com.arfood.controller;

import com.arfood.dto.ParkDto;
import com.arfood.entity.Park;
import com.arfood.mapper.ParkMapper;
import com.arfood.repository.ParkRepository;
import com.arfood.service.AuditLogService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/parks")
@RequiredArgsConstructor
public class ParkController {

    private final ParkRepository parkRepository;
    private final ParkMapper parkMapper;
    private final AuditLogService auditLogService;

    @GetMapping
    public ResponseEntity<List<ParkDto>> getAllParks() {
        List<Park> parks = parkRepository.findByActiveTrue();
        List<ParkDto> parkDtos = parks.stream()
                .map(parkMapper::toDto)
                .collect(Collectors.toList());
        return ResponseEntity.ok(parkDtos);
    }

    @GetMapping("/{id}")
    public ResponseEntity<ParkDto> getParkById(@PathVariable Long id) {
        Park park = parkRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Park not found"));
        return ResponseEntity.ok(parkMapper.toDto(park));
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ParkDto> createPark(@Valid @RequestBody ParkDto parkDto) {
        Park park = parkMapper.toEntity(parkDto);
        Park savedPark = parkRepository.save(park);
        
        auditLogService.logAuditEvent(
                "ADMIN",
                "CREATE_PARK",
                "Park",
                savedPark.getId(),
                null,
                "SUCCESS",
                "Created new park: " + savedPark.getName()
        );
        
        return ResponseEntity.ok(parkMapper.toDto(savedPark));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ParkDto> updatePark(@PathVariable Long id, @Valid @RequestBody ParkDto parkDto) {
        Park park = parkRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Park not found"));
        
        park.setName(parkDto.getName());
        park.setLocation(parkDto.getLocation());
        park.setDescription(parkDto.getDescription());
        park.setLatitude(parkDto.getLatitude());
        park.setLongitude(parkDto.getLongitude());
        park.setImageUrl(parkDto.getImageUrl());
        park.setActive(parkDto.getActive());
        
        Park updatedPark = parkRepository.save(park);
        
        auditLogService.logAuditEvent(
                "ADMIN",
                "UPDATE_PARK",
                "Park",
                updatedPark.getId(),
                null,
                "SUCCESS",
                "Updated park: " + updatedPark.getName()
        );
        
        return ResponseEntity.ok(parkMapper.toDto(updatedPark));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> deletePark(@PathVariable Long id) {
        Park park = parkRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Park not found"));
        
        parkRepository.delete(park);
        
        auditLogService.logAuditEvent(
                "ADMIN",
                "DELETE_PARK",
                "Park",
                id,
                null,
                "SUCCESS",
                "Deleted park: " + park.getName()
        );
        
        return ResponseEntity.noContent().build();
    }
}
