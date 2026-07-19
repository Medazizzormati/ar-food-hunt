package com.arfood.repository;

import com.arfood.entity.Collectible;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CollectibleRepository extends JpaRepository<Collectible, Long> {
    List<Collectible> findByAvailableTrue();
    List<Collectible> findByFoodTruckId(Long foodTruckId);
    List<Collectible> findByType(com.arfood.enums.CollectibleType type);
}
