package com.arfood.repository;

import com.arfood.entity.Park;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ParkRepository extends JpaRepository<Park, Long> {
    List<Park> findByActiveTrue();
    Optional<Park> findByName(String name);
}
