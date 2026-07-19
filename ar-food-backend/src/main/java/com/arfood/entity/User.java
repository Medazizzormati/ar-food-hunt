package com.arfood.entity;

import com.arfood.enums.CollectibleType;
import com.arfood.enums.Role;
import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "users")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class User {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(unique = true, nullable = false)
    private String username;
    
    @Column(unique = true, nullable = false)
    private String email;
    
    @Column(nullable = false)
    private String password;
    
    private Integer level = 1;
    
    private Integer xp = 0;
    
    private Integer coins = 0;
    
    private String avatar;
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Role role = Role.USER;
    
    @Column(name = "account_non_expired")
    private Boolean accountNonExpired = true;
    
    @Column(name = "account_non_locked")
    private Boolean accountNonLocked = true;
    
    @Column(name = "credentials_non_expired")
    private Boolean credentialsNonExpired = true;
    
    @Column(name = "enabled")
    private Boolean enabled = true;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt = LocalDateTime.now();
    
    @ManyToMany(mappedBy = "users")
    private Set<Collection> collections = new HashSet<>();
    
    @OneToMany(mappedBy = "user")
    private Set<Reward> rewards = new HashSet<>();
    
    @ManyToMany(mappedBy = "users")
    private Set<Achievement> achievements = new HashSet<>();
    
    @PreUpdate
    public void preUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
    
    public void collectItem(Collectible collectible) {
        this.xp += collectible.getXpReward();
        this.coins += collectible.getCoinReward();
        checkLevelUp();
    }
    
    public void gainXP(int xp) {
        this.xp += xp;
        checkLevelUp();
    }
    
    private void checkLevelUp() {
        int xpNeeded = this.level * 100;
        if (this.xp >= xpNeeded) {
            this.level++;
            this.xp -= xpNeeded;
        }
    }
    
    public void levelUp() {
        this.level++;
    }
    
    public void claimReward(Reward reward) {
        this.rewards.add(reward);
    }
}
