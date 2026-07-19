package com.arfood.mapper;

import com.arfood.dto.EventDto;
import com.arfood.entity.Event;
import org.springframework.stereotype.Component;

@Component
public class EventMapper {
    
    public EventDto toDto(Event event) {
        return EventDto.builder()
                .id(event.getId())
                .name(event.getName())
                .startDate(event.getStartDate())
                .endDate(event.getEndDate())
                .active(event.getActive())
                .build();
    }
    
    public Event toEntity(EventDto eventDto) {
        return Event.builder()
                .id(eventDto.getId())
                .name(eventDto.getName())
                .startDate(eventDto.getStartDate())
                .endDate(eventDto.getEndDate())
                .active(eventDto.getActive() != null ? eventDto.getActive() : false)
                .build();
    }
    
    public void updateEntityFromDto(EventDto eventDto, Event event) {
        if (eventDto.getName() != null) event.setName(eventDto.getName());
        if (eventDto.getStartDate() != null) event.setStartDate(eventDto.getStartDate());
        if (eventDto.getEndDate() != null) event.setEndDate(eventDto.getEndDate());
        if (eventDto.getActive() != null) event.setActive(eventDto.getActive());
    }
}
