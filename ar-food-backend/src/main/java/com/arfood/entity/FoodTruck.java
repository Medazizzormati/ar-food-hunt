package com.arfood.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "food_trucks")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class FoodTruck {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String name;
    
    private String category;
    
    private Double latitude;
    
    private Double longitude;
    
    @Column(columnDefinition = "TEXT")
    private String description;
    
    @OneToMany(mappedBy = "foodTruck", cascade = CascadeType.ALL)
    private Set<Collectible> collectibles = new HashSet<>();
    
    @ManyToMany
    @JoinTable(
        name = "foodtruck_collections",
        joinColumns = @JoinColumn(name = "food_truck_id"),
        inverseJoinColumns = @JoinColumn(name = "collection_id")
    )
    private Set<Collection> collections = new HashSet<>();
    
    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt = LocalDateTime.now();
    
    @PreUpdate
    public void preUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
    
    public void spawnCollectibles(Collectible collectible) {
        this.collectibles.add(collectible);
    }
}
