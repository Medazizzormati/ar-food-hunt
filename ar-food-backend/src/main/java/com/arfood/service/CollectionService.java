package com.arfood.service;

import com.arfood.entity.Collection;
import com.arfood.entity.User;
import com.arfood.entity.Event;
import com.arfood.repository.CollectionRepository;
import com.arfood.repository.UserRepository;
import com.arfood.repository.EventRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class CollectionService {
    
    private final CollectionRepository collectionRepository;
    private final UserRepository userRepository;
    private final EventRepository eventRepository;
    
    public List<Collection> getAllCollections() {
        return collectionRepository.findAll();
    }
    
    public List<Collection> getCollectionsByEventId(Long eventId) {
        return collectionRepository.findByEventId(eventId);
    }
    
    public Optional<Collection> getCollectionById(Long id) {
        return collectionRepository.findById(id);
    }
    
    public Collection createCollection(Collection collection) {
        return collectionRepository.save(collection);
    }
    
    public Collection updateCollection(Long id, Collection collectionDetails) {
        Collection collection = collectionRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Collection not found"));
        
        collection.setTitle(collectionDetails.getTitle());
        collection.setRewardXP(collectionDetails.getRewardXP());
        collection.setRewardCoins(collectionDetails.getRewardCoins());
        
        return collectionRepository.save(collection);
    }
    
    public Collection completeCollection(Long collectionId, Long userId) {
        Collection collection = collectionRepository.findById(collectionId)
                .orElseThrow(() -> new RuntimeException("Collection not found"));
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        if (!collection.isCompleted(user)) {
            collection.getUsers().add(user);
            user.gainXP(collection.getRewardXP());
            user.setCoins(user.getCoins() + collection.getRewardCoins());
            userRepository.save(user);
        }
        
        return collectionRepository.save(collection);
    }
    
    public void deleteCollection(Long id) {
        collectionRepository.deleteById(id);
    }
}
