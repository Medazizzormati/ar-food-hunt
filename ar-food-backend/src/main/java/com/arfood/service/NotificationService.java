package com.arfood.service;

import com.arfood.entity.Event;
import com.arfood.entity.User;
import com.arfood.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class NotificationService {

    private final UserRepository userRepository;
    // Add OneSignal or other notification service integration here

    public void sendEventStartingNotification(Event event) {
        List<User> allUsers = userRepository.findAll();
        String title = "Event Starting Soon!";
        String message = String.format("%s is starting in 5 minutes. Don't miss out!", event.getName());
        
        for (User user : allUsers) {
            sendPushNotification(user, title, message);
        }
    }

    public void sendEventEndingNotification(Event event) {
        List<User> allUsers = userRepository.findAll();
        String title = "Event Ending Soon!";
        String message = String.format("%s is ending in 5 minutes. Collect your items now!", event.getName());
        
        for (User user : allUsers) {
            sendPushNotification(user, title, message);
        }
    }

    public void sendCollectibleSpawnNotification(String collectibleName, String foodTruckName) {
        List<User> allUsers = userRepository.findAll();
        String title = "New Collectible Available!";
        String message = String.format("%s just spawned at %s. Go collect it!", collectibleName, foodTruckName);
        
        for (User user : allUsers) {
            sendPushNotification(user, title, message);
        }
    }

    public void sendLevelUpNotification(User user, int newLevel) {
        String title = "Level Up!";
        String message = String.format("Congratulations! You reached level %d!", newLevel);
        sendPushNotification(user, title, message);
    }

    private void sendPushNotification(User user, String title, String message) {
        // Integrate with OneSignal or other push notification service
        log.info("Sending notification to user {}: {} - {}", user.getUsername(), title, message);
        
        // Example OneSignal integration:
        // OneSignal.postNotification(new JSONObject("{'contents': {'en': '" + message + "'}, 'headings': {'en': '" + title + "'}, 'include_player_ids': ['" + user.getOneSignalId() + "']}"));
    }
}
