package com.arfood.entity;

import com.arfood.enums.CollectibleType;
import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "collectibles")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Collectible {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String name;
    
    private String model3D;
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private CollectibleType type;
    
    @Column(name = "xp_reward")
    private Integer xpReward;
    
    @Column(name = "coin_reward")
    private Integer coinReward;
    
    private Double latitude;
    
    private Double longitude;
    
    private Boolean available = true;
    
    @ManyToOne
    @JoinColumn(name = "food_truck_id")
    private FoodTruck foodTruck;
    
    @ManyToMany(mappedBy = "collectibles")
    private Set<Collection> collections = new HashSet<>();
    
    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt = LocalDateTime.now();
    
    @PreUpdate
    public void preUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
    
    public void collect() {
        this.available = false;
    }
}
