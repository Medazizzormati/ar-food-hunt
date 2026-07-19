package com.arfood.service;

import com.arfood.entity.Collectible;
import com.arfood.entity.User;
import com.arfood.entity.FoodTruck;
import com.arfood.repository.CollectibleRepository;
import com.arfood.repository.UserRepository;
import com.arfood.repository.FoodTruckRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class CollectibleService {
    
    private final CollectibleRepository collectibleRepository;
    private final UserRepository userRepository;
    private final FoodTruckRepository foodTruckRepository;
    
    public List<Collectible> getAllCollectibles() {
        return collectibleRepository.findAll();
    }
    
    public List<Collectible> getAvailableCollectibles() {
        return collectibleRepository.findByAvailableTrue();
    }
    
    public List<Collectible> getCollectiblesByFoodTruckId(Long foodTruckId) {
        return collectibleRepository.findByFoodTruckId(foodTruckId);
    }
    
    public List<Collectible> getCollectiblesByType(com.arfood.enums.CollectibleType type) {
        return collectibleRepository.findByType(type);
    }
    
    public Optional<Collectible> getCollectibleById(Long id) {
        return collectibleRepository.findById(id);
    }
    
    public Collectible createCollectible(Collectible collectible) {
        return collectibleRepository.save(collectible);
    }
    
    public Collectible updateCollectible(Long id, Collectible collectibleDetails) {
        Collectible collectible = collectibleRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Collectible not found"));
        
        collectible.setName(collectibleDetails.getName());
        collectible.setModel3D(collectibleDetails.getModel3D());
        collectible.setType(collectibleDetails.getType());
        collectible.setXpReward(collectibleDetails.getXpReward());
        collectible.setCoinReward(collectibleDetails.getCoinReward());
        collectible.setLatitude(collectibleDetails.getLatitude());
        collectible.setLongitude(collectibleDetails.getLongitude());
        collectible.setAvailable(collectibleDetails.getAvailable());
        
        return collectibleRepository.save(collectible);
    }
    
    public Collectible collectCollectible(Long collectibleId, Long userId) {
        Collectible collectible = collectibleRepository.findById(collectibleId)
                .orElseThrow(() -> new RuntimeException("Collectible not found"));
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        if (!collectible.getAvailable()) {
            throw new RuntimeException("Collectible is not available");
        }
        
        collectible.collect();
        user.collectItem(collectible);
        userRepository.save(user);
        
        return collectibleRepository.save(collectible);
    }
    
    public void deleteCollectible(Long id) {
        collectibleRepository.deleteById(id);
    }
}
