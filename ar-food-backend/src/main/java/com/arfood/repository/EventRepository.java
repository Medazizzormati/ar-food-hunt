package com.arfood.repository;

import com.arfood.entity.Event;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface EventRepository extends JpaRepository<Event, Long> {
    List<Event> findByActiveTrue();
    List<Event> findByActiveFalse();
    List<Event> findByStartTimeBetweenAndActive(LocalDateTime start, LocalDateTime end, boolean active);
    List<Event> findByEndTimeBetweenAndActive(LocalDateTime start, LocalDateTime end, boolean active);
}
