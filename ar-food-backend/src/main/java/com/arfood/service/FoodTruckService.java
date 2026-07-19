package com.arfood.service;

import com.arfood.entity.FoodTruck;
import com.arfood.repository.FoodTruckRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class FoodTruckService {
    
    private final FoodTruckRepository foodTruckRepository;
    
    public List<FoodTruck> getAllFoodTrucks() {
        return foodTruckRepository.findAll();
    }
    
    public List<FoodTruck> getFoodTrucksByCategory(String category) {
        return foodTruckRepository.findByCategory(category);
    }
    
    public Optional<FoodTruck> getFoodTruckById(Long id) {
        return foodTruckRepository.findById(id);
    }
    
    public FoodTruck createFoodTruck(FoodTruck foodTruck) {
        return foodTruckRepository.save(foodTruck);
    }
    
    public FoodTruck updateFoodTruck(Long id, FoodTruck foodTruckDetails) {
        FoodTruck foodTruck = foodTruckRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("FoodTruck not found"));
        
        foodTruck.setName(foodTruckDetails.getName());
        foodTruck.setCategory(foodTruckDetails.getCategory());
        foodTruck.setLatitude(foodTruckDetails.getLatitude());
        foodTruck.setLongitude(foodTruckDetails.getLongitude());
        foodTruck.setDescription(foodTruckDetails.getDescription());
        
        return foodTruckRepository.save(foodTruck);
    }
    
    public void deleteFoodTruck(Long id) {
        foodTruckRepository.deleteById(id);
    }
}
