package com.arfood.controller;

import com.arfood.annotation.Auditable;
import com.arfood.dto.EventDto;
import com.arfood.entity.Event;
import com.arfood.exception.ResourceNotFoundException;
import com.arfood.mapper.EventMapper;
import com.arfood.service.EventService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/events")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class EventController {
    
    private final EventService eventService;
    private final EventMapper eventMapper;
    
    @GetMapping
    @Auditable
    public ResponseEntity<List<EventDto>> getAllEvents() {
        List<Event> events = eventService.getAllEvents();
        List<EventDto> eventDtos = events.stream()
                .map(eventMapper::toDto)
                .collect(Collectors.toList());
        return ResponseEntity.ok(eventDtos);
    }
    
    @GetMapping("/active")
    @Auditable
    public ResponseEntity<List<EventDto>> getActiveEvents() {
        List<Event> events = eventService.getActiveEvents();
        List<EventDto> eventDtos = events.stream()
                .map(eventMapper::toDto)
                .collect(Collectors.toList());
        return ResponseEntity.ok(eventDtos);
    }
    
    @GetMapping("/{id}")
    @Auditable
    public ResponseEntity<EventDto> getEventById(@PathVariable Long id) {
        Event event = eventService.getEventById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Event", id));
        return ResponseEntity.ok(eventMapper.toDto(event));
    }
    
    @PostMapping
    @PreAuthorize("hasAnyRole('MODERATOR', 'ADMIN')")
    @Auditable
    public ResponseEntity<EventDto> createEvent(@Valid @RequestBody EventDto eventDto) {
        Event event = eventMapper.toEntity(eventDto);
        Event createdEvent = eventService.createEvent(event);
        return ResponseEntity.ok(eventMapper.toDto(createdEvent));
    }
    
    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('MODERATOR', 'ADMIN')")
    @Auditable
    public ResponseEntity<EventDto> updateEvent(@PathVariable Long id, @Valid @RequestBody EventDto eventDto) {
        Event existingEvent = eventService.getEventById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Event", id));
        
        eventMapper.updateEntityFromDto(eventDto, existingEvent);
        Event updatedEvent = eventService.updateEvent(id, existingEvent);
        
        return ResponseEntity.ok(eventMapper.toDto(updatedEvent));
    }
    
    @PostMapping("/{id}/activate")
    @PreAuthorize("hasAnyRole('MODERATOR', 'ADMIN')")
    @Auditable
    public ResponseEntity<EventDto> activateEvent(@PathVariable Long id) {
        Event event = eventService.activateEvent(id);
        return ResponseEntity.ok(eventMapper.toDto(event));
    }
    
    @PostMapping("/{id}/deactivate")
    @PreAuthorize("hasAnyRole('MODERATOR', 'ADMIN')")
    @Auditable
    public ResponseEntity<EventDto> deactivateEvent(@PathVariable Long id) {
        Event event = eventService.deactivateEvent(id);
        return ResponseEntity.ok(eventMapper.toDto(event));
    }
    
    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('MODERATOR', 'ADMIN')")
    @Auditable
    public ResponseEntity<Void> deleteEvent(@PathVariable Long id) {
        eventService.deleteEvent(id);
        return ResponseEntity.noContent().build();
    }
}
