package com.arfood.scheduler;

import com.arfood.service.NotificationService;
import com.arfood.entity.Event;
import com.arfood.repository.EventRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.List;

@Component
@RequiredArgsConstructor
@Slf4j
public class NotificationScheduler {

    private final NotificationService notificationService;
    private final EventRepository eventRepository;

    @Scheduled(cron = "0 * * * * ?") // Every minute
    public void checkEventStartNotifications() {
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime inFiveMinutes = now.plusMinutes(5);
        
        List<Event> eventsStartingSoon = eventRepository
            .findByStartTimeBetweenAndActive(now, inFiveMinutes, true);
        
        for (Event event : eventsStartingSoon) {
            notificationService.sendEventStartingNotification(event);
            log.info("Sent notification for event starting soon: {}", event.getName());
        }
    }

    @Scheduled(cron = "0 * * * * ?") // Every minute
    public void checkEventEndingNotifications() {
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime inFiveMinutes = now.plusMinutes(5);
        
        List<Event> eventsEndingSoon = eventRepository
            .findByEndTimeBetweenAndActive(now, inFiveMinutes, true);
        
        for (Event event : eventsEndingSoon) {
            notificationService.sendEventEndingNotification(event);
            log.info("Sent notification for event ending soon: {}", event.getName());
        }
    }

    @Scheduled(cron = "0 0 * * * ?") // Every hour
    public void checkCollectibleSpawnNotifications() {
        // This would check for collectibles that are about to spawn
        // Implementation depends on collectible spawn logic
        log.info("Checking collectible spawn notifications");
    }
}
