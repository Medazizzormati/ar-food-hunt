package com.arfood.service;

import com.arfood.entity.Reward;
import com.arfood.entity.User;
import com.arfood.entity.Event;
import com.arfood.repository.RewardRepository;
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
public class RewardService {
    
    private final RewardRepository rewardRepository;
    private final UserRepository userRepository;
    private final EventRepository eventRepository;
    
    public List<Reward> getAllRewards() {
        return rewardRepository.findAll();
    }
    
    public List<Reward> getRewardsByUserId(Long userId) {
        return rewardRepository.findByUserId(userId);
    }
    
    public List<Reward> getRewardsByEventId(Long eventId) {
        return rewardRepository.findByEventId(eventId);
    }
    
    public List<Reward> getUnredeemedRewardsByUserId(Long userId) {
        return rewardRepository.findByUserIdAndRedeemedFalse(userId);
    }
    
    public Optional<Reward> getRewardById(Long id) {
        return rewardRepository.findById(id);
    }
    
    public Reward createReward(Reward reward) {
        return rewardRepository.save(reward);
    }
    
    public Reward updateReward(Long id, Reward rewardDetails) {
        Reward reward = rewardRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Reward not found"));
        
        reward.setTitle(rewardDetails.getTitle());
        reward.setType(rewardDetails.getType());
        reward.setValue(rewardDetails.getValue());
        
        return rewardRepository.save(reward);
    }
    
    public Reward redeemReward(Long id) {
        Reward reward = rewardRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Reward not found"));
        reward.redeem();
        return rewardRepository.save(reward);
    }
    
    public Reward assignRewardToUser(Long rewardId, Long userId) {
        Reward reward = rewardRepository.findById(rewardId)
                .orElseThrow(() -> new RuntimeException("Reward not found"));
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        reward.setUser(user);
        user.claimReward(reward);
        userRepository.save(user);
        return rewardRepository.save(reward);
    }
    
    public void deleteReward(Long id) {
        rewardRepository.deleteById(id);
    }
}
