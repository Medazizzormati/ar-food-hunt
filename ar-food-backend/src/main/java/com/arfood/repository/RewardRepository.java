package com.arfood.repository;

import com.arfood.entity.Reward;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RewardRepository extends JpaRepository<Reward, Long> {
    List<Reward> findByUserId(Long userId);
    List<Reward> findByEventId(Long eventId);
    List<Reward> findByUserIdAndRedeemedFalse(Long userId);
}
