-- ============================================
-- AR Food Hunt - PostgreSQL Database Schema
-- ============================================
-- Complete schema with all tables, relationships, constraints
-- CRUD queries for each table
-- Sample data for testing
-- ============================================

-- Drop existing database if exists
DROP DATABASE IF EXISTS ar_food_hunt;

-- Create database
CREATE DATABASE ar_food_hunt;
\c ar_food_hunt;

-- ============================================
-- TABLES
-- ============================================

-- Users table
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'USER' CHECK (role IN ('USER', 'MODERATOR', 'ADMIN')),
    coins INTEGER DEFAULT 0,
    xp INTEGER DEFAULT 0,
    level INTEGER DEFAULT 1,
    account_enabled BOOLEAN DEFAULT TRUE,
    account_non_locked BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Events table
CREATE TABLE events (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP NOT NULL,
    location VARCHAR(200),
    is_active BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Achievements table
CREATE TABLE achievements (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    xp_reward INTEGER NOT NULL,
    coin_reward INTEGER NOT NULL,
    icon_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- User Achievements junction table
CREATE TABLE user_achievements (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    achievement_id BIGINT NOT NULL,
    unlocked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (achievement_id) REFERENCES achievements(id) ON DELETE CASCADE,
    UNIQUE(user_id, achievement_id)
);

-- Rewards table
CREATE TABLE rewards (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    type VARCHAR(50) NOT NULL CHECK (type IN ('COUPON', 'DISCOUNT', 'ITEM', 'XP', 'COINS')),
    value INTEGER,
    expiry_date TIMESTAMP,
    image_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- User Rewards junction table
CREATE TABLE user_rewards (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    reward_id BIGINT NOT NULL,
    event_id BIGINT,
    is_redeemed BOOLEAN DEFAULT FALSE,
    redeemed_at TIMESTAMP,
    earned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (reward_id) REFERENCES rewards(id) ON DELETE CASCADE,
    FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE SET NULL
);

-- Collections table
CREATE TABLE collections (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    xp_reward INTEGER NOT NULL,
    coin_reward INTEGER NOT NULL,
    total_items INTEGER NOT NULL,
    icon_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- User Collections junction table
CREATE TABLE user_collections (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    collection_id BIGINT NOT NULL,
    progress INTEGER DEFAULT 0,
    is_completed BOOLEAN DEFAULT FALSE,
    completed_at TIMESTAMP,
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (collection_id) REFERENCES collections(id) ON DELETE CASCADE,
    UNIQUE(user_id, collection_id)
);

-- Food Trucks table
CREATE TABLE food_trucks (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    category VARCHAR(50) NOT NULL CHECK (category IN ('Burgers', 'Pizza', 'Dessert', 'Coffee', 'Asian', 'Mexican', 'Other')),
    latitude DECIMAL(10, 8) NOT NULL,
    longitude DECIMAL(11, 8) NOT NULL,
    address VARCHAR(200),
    phone VARCHAR(20),
    opening_hours VARCHAR(100),
    image_url VARCHAR(500),
    rating DECIMAL(3, 2) DEFAULT 0.0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Collectibles table
CREATE TABLE collectibles (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    rarity VARCHAR(20) NOT NULL CHECK (rarity IN ('COMMON', 'RARE', 'LEGENDARY', 'EPIC')),
    xp_reward INTEGER NOT NULL,
    coin_reward INTEGER NOT NULL,
    food_truck_id BIGINT,
    collection_id BIGINT,
    type VARCHAR(50) NOT NULL CHECK (type IN ('FOOD', 'DRINK', 'DESSERT', 'SPECIAL')),
    image_url VARCHAR(500),
    is_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (food_truck_id) REFERENCES food_trucks(id) ON DELETE SET NULL,
    FOREIGN KEY (collection_id) REFERENCES collections(id) ON DELETE SET NULL
);

-- User Collectibles junction table
CREATE TABLE user_collectibles (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    collectible_id BIGINT NOT NULL,
    collected_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (collectible_id) REFERENCES collectibles(id) ON DELETE CASCADE,
    UNIQUE(user_id, collectible_id)
);

-- Audit Logs table
CREATE TABLE audit_logs (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(50),
    action VARCHAR(100) NOT NULL,
    entity_type VARCHAR(50),
    entity_id BIGINT,
    ip_address VARCHAR(45),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'SUCCESS' CHECK (status IN ('SUCCESS', 'FAILURE')),
    details TEXT
);

-- ============================================
-- INDEXES
-- ============================================

CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);

CREATE INDEX idx_events_active ON events(is_active);
CREATE INDEX idx_events_dates ON events(start_date, end_date);

CREATE INDEX idx_food_trucks_category ON food_trucks(category);
CREATE INDEX idx_food_trucks_location ON food_trucks(latitude, longitude);
CREATE INDEX idx_food_trucks_active ON food_trucks(is_active);

CREATE INDEX idx_collectibles_rarity ON collectibles(rarity);
CREATE INDEX idx_collectibles_available ON collectibles(is_available);
CREATE INDEX idx_collectibles_truck ON collectibles(food_truck_id);
CREATE INDEX idx_collectibles_collection ON collectibles(collection_id);

CREATE INDEX idx_user_collectibles_user ON user_collectibles(user_id);
CREATE INDEX idx_user_collectibles_collectible ON user_collectibles(collectible_id);

CREATE INDEX idx_user_achievements_user ON user_achievements(user_id);
CREATE INDEX idx_user_achievements_achievement ON user_achievements(achievement_id);

CREATE INDEX idx_user_rewards_user ON user_rewards(user_id);
CREATE INDEX idx_user_rewards_reward ON user_rewards(reward_id);
CREATE INDEX idx_user_rewards_redeemed ON user_rewards(is_redeemed);

CREATE INDEX idx_user_collections_user ON user_collections(user_id);
CREATE INDEX idx_user_collections_collection ON user_collections(collection_id);
CREATE INDEX idx_user_collections_completed ON user_collections(is_completed);

CREATE INDEX idx_audit_logs_username ON audit_logs(username);
CREATE INDEX idx_audit_logs_timestamp ON audit_logs(timestamp);
CREATE INDEX idx_audit_logs_action ON audit_logs(action);

-- ============================================
-- FUNCTIONS AND TRIGGERS
-- ============================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers for updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_events_updated_at BEFORE UPDATE ON events
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_achievements_updated_at BEFORE UPDATE ON achievements
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_rewards_updated_at BEFORE UPDATE ON rewards
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_collections_updated_at BEFORE UPDATE ON collections
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_food_trucks_updated_at BEFORE UPDATE ON food_trucks
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_collectibles_updated_at BEFORE UPDATE ON collectibles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- SAMPLE DATA
-- ============================================

-- Insert sample users
INSERT INTO users (username, email, password, role, coins, xp, level) VALUES
('admin', 'admin@arfood.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'ADMIN', 1000, 5000, 10),
('moderator', 'mod@arfood.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'MODERATOR', 500, 2500, 5),
('user1', 'user1@arfood.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'USER', 100, 500, 2),
('user2', 'user2@arfood.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'USER', 50, 200, 1);

-- Insert sample events
INSERT INTO events (name, description, start_date, end_date, location, is_active) VALUES
('Summer Food Festival', 'Annual summer food truck festival with 50+ trucks', '2024-06-01 10:00:00', '2024-06-30 22:00:00', 'Central Park', TRUE),
('Weekend Market', 'Weekend food market with local vendors', '2024-07-06 09:00:00', '2024-07-07 18:00:00', 'Downtown Square', TRUE),
('Taco Tuesday', 'Special taco truck gathering every Tuesday', '2024-07-01 11:00:00', '2024-12-31 21:00:00', 'Food Court', FALSE);

-- Insert sample achievements
INSERT INTO achievements (name, description, xp_reward, coin_reward, icon_url) VALUES
('First Collection', 'Complete your first collection', 100, 50, '/icons/first_collection.png'),
('Food Explorer', 'Collect 10 different food items', 200, 100, '/icons/food_explorer.png'),
('Master Hunter', 'Collect 50 collectibles', 500, 250, '/icons/master_hunter.png'),
('Event Champion', 'Complete all event collections', 1000, 500, '/icons/event_champion.png');

-- Insert sample rewards
INSERT INTO rewards (name, description, type, value, expiry_date, image_url) VALUES
('Free Burger Coupon', 'Get a free burger from any participating truck', 'COUPON', 1, '2024-12-31 23:59:59', '/rewards/burger_coupon.png'),
('20% Discount', '20% off your next purchase', 'DISCOUNT', 20, '2024-12-31 23:59:59', '/rewards/discount_20.png'),
('500 XP Boost', 'Instant 500 XP bonus', 'XP', 500, NULL, '/rewards/xp_boost.png'),
('100 Coins', 'Instant 100 coins bonus', 'COINS', 100, NULL, '/rewards/coins_100.png');

-- Insert sample collections
INSERT INTO collections (name, description, xp_reward, coin_reward, total_items, icon_url) VALUES
('Burger Collection', 'Collect all burger varieties', 300, 150, 5, '/collections/burgers.png'),
('Pizza Collection', 'Collect all pizza types', 400, 200, 6, '/collections/pizza.png'),
('Dessert Collection', 'Collect all sweet treats', 350, 175, 8, '/collections/dessert.png'),
('Coffee Collection', 'Collect all coffee drinks', 250, 125, 4, '/collections/coffee.png');

-- Insert sample food trucks
INSERT INTO food_trucks (name, description, category, latitude, longitude, address, phone, opening_hours, image_url, rating, is_active) VALUES
('Burger Palace', 'Gourmet burgers with unique toppings', 'Burgers', 40.7128, -74.0060, '123 Main St', '555-0101', '11:00-22:00', '/trucks/burger_palace.jpg', 4.5, TRUE),
('Pizza Heaven', 'Authentic Italian pizza', 'Pizza', 40.7138, -74.0070, '456 Oak Ave', '555-0102', '12:00-23:00', '/trucks/pizza_heaven.jpg', 4.7, TRUE),
('Sweet Treats', 'Homemade desserts and pastries', 'Dessert', 40.7148, -74.0080, '789 Pine Rd', '555-0103', '10:00-20:00', '/trucks/sweet_treats.jpg', 4.3, TRUE),
('Coffee Corner', 'Specialty coffee and espresso drinks', 'Coffee', 40.7158, -74.0090, '321 Elm St', '555-0104', '07:00-18:00', '/trucks/coffee_corner.jpg', 4.6, TRUE),
('Taco Fiesta', 'Authentic Mexican tacos and burritos', 'Mexican', 40.7168, -74.0100, '654 Maple Dr', '555-0105', '11:00-21:00', '/trucks/taco_fiesta.jpg', 4.4, TRUE);

-- Insert sample collectibles
INSERT INTO collectibles (name, description, rarity, xp_reward, coin_reward, food_truck_id, collection_id, type, image_url, is_available) VALUES
('Classic Burger', 'Traditional beef burger with lettuce and tomato', 'COMMON', 50, 25, 1, 1, 'FOOD', '/collectibles/classic_burger.png', TRUE),
('Cheese Burger', 'Double cheese burger with special sauce', 'COMMON', 50, 25, 1, 1, 'FOOD', '/collectibles/cheese_burger.png', TRUE),
('Bacon Burger', 'Bacon wrapped burger with caramelized onions', 'RARE', 100, 50, 1, 1, 'FOOD', '/collectibles/bacon_burger.png', TRUE),
('Veggie Burger', 'Plant-based burger with avocado', 'RARE', 100, 50, 1, 1, 'FOOD', '/collectibles/veggie_burger.png', TRUE),
('Gourmet Burger', 'Truffle burger with aged cheddar', 'LEGENDARY', 200, 100, 1, 1, 'FOOD', '/collectibles/gourmet_burger.png', TRUE),
('Margherita Pizza', 'Classic pizza with tomato, mozzarella, basil', 'COMMON', 50, 25, 2, 2, 'FOOD', '/collectibles/margherita.png', TRUE),
('Pepperoni Pizza', 'Pepperoni pizza with extra cheese', 'COMMON', 50, 25, 2, 2, 'FOOD', '/collectibles/pepperoni.png', TRUE),
('BBQ Chicken Pizza', 'BBQ chicken pizza with red onions', 'RARE', 100, 50, 2, 2, 'FOOD', '/collectibles/bbq_chicken.png', TRUE),
('Seafood Pizza', 'Pizza with shrimp and calamari', 'LEGENDARY', 200, 100, 2, 2, 'FOOD', '/collectibles/seafood.png', TRUE),
('Chocolate Cake', 'Rich chocolate layer cake', 'COMMON', 50, 25, 3, 3, 'DESSERT', '/collectibles/chocolate_cake.png', TRUE),
('Ice Cream Sundae', 'Classic ice cream sundae with toppings', 'COMMON', 50, 25, 3, 3, 'DESSERT', '/collectibles/sundae.png', TRUE),
('Tiramisu', 'Italian coffee-flavored dessert', 'RARE', 100, 50, 3, 3, 'DESSERT', '/collectibles/tiramisu.png', TRUE),
('Espresso', 'Classic Italian espresso', 'COMMON', 30, 15, 4, 4, 'DRINK', '/collectibles/espresso.png', TRUE),
('Cappuccino', 'Espresso with steamed milk foam', 'COMMON', 30, 15, 4, 4, 'DRINK', '/collectibles/cappuccino.png', TRUE),
('Latte', 'Espresso with steamed milk', 'RARE', 50, 25, 4, 4, 'DRINK', '/collectibles/latte.png', TRUE);

-- Insert sample user collectibles
INSERT INTO user_collectibles (user_id, collectible_id) VALUES
(3, 1), (3, 2), (3, 6), (3, 10),
(4, 1), (4, 6);

-- Insert sample user achievements
INSERT INTO user_achievements (user_id, achievement_id) VALUES
(3, 1);

-- ============================================
-- CRUD QUERIES
-- ============================================

-- ============================================
-- USERS CRUD QUERIES
-- ============================================

-- CREATE
INSERT INTO users (username, email, password, role, coins, xp, level) 
VALUES ($1, $2, $3, $4, $5, $6, $7);

-- READ ALL
SELECT * FROM users ORDER BY created_at DESC;

-- READ BY ID
SELECT * FROM users WHERE id = $1;

-- READ BY USERNAME
SELECT * FROM users WHERE username = $1;

-- READ BY EMAIL
SELECT * FROM users WHERE email = $1;

-- UPDATE
UPDATE users 
SET username = $2, email = $3, password = $4, role = $5, coins = $6, xp = $7, level = $8, updated_at = CURRENT_TIMESTAMP
WHERE id = $1;

-- ADD COINS
UPDATE users SET coins = coins + $2 WHERE id = $1;

-- ADD XP
UPDATE users SET xp = xp + $2 WHERE id = $1;

-- DELETE
DELETE FROM users WHERE id = $1;

-- ============================================
-- EVENTS CRUD QUERIES
-- ============================================

-- CREATE
INSERT INTO events (name, description, start_date, end_date, location, is_active) 
VALUES ($1, $2, $3, $4, $5, $6);

-- READ ALL
SELECT * FROM events ORDER BY start_date;

-- READ ACTIVE
SELECT * FROM events WHERE is_active = TRUE ORDER BY start_date;

-- READ BY ID
SELECT * FROM events WHERE id = $1;

-- UPDATE
UPDATE events 
SET name = $2, description = $3, start_date = $4, end_date = $5, location = $6, is_active = $7, updated_at = CURRENT_TIMESTAMP
WHERE id = $1;

-- ACTIVATE
UPDATE events SET is_active = TRUE WHERE id = $1;

-- DEACTIVATE
UPDATE events SET is_active = FALSE WHERE id = $1;

-- DELETE
DELETE FROM events WHERE id = $1;

-- ============================================
-- ACHIEVEMENTS CRUD QUERIES
-- ============================================

-- CREATE
INSERT INTO achievements (name, description, xp_reward, coin_reward, icon_url) 
VALUES ($1, $2, $3, $4, $5);

-- READ ALL
SELECT * FROM achievements ORDER BY xp_reward;

-- READ BY ID
SELECT * FROM achievements WHERE id = $1;

-- UPDATE
UPDATE achievements 
SET name = $2, description = $3, xp_reward = $4, coin_reward = $5, icon_url = $6, updated_at = CURRENT_TIMESTAMP
WHERE id = $1;

-- DELETE
DELETE FROM achievements WHERE id = $1;

-- ============================================
-- USER ACHIEVEMENTS CRUD QUERIES
-- ============================================

-- CREATE (UNLOCK)
INSERT INTO user_achievements (user_id, achievement_id) 
VALUES ($1, $2);

-- READ ALL BY USER
SELECT ua.*, a.name as achievement_name, a.description, a.xp_reward, a.coin_reward 
FROM user_achievements ua
JOIN achievements a ON ua.achievement_id = a.id
WHERE ua.user_id = $1
ORDER BY ua.unlocked_at DESC;

-- READ BY USER AND ACHIEVEMENT
SELECT * FROM user_achievements WHERE user_id = $1 AND achievement_id = $2;

-- DELETE
DELETE FROM user_achievements WHERE user_id = $1 AND achievement_id = $2;

-- ============================================
-- REWARDS CRUD QUERIES
-- ============================================

-- CREATE
INSERT INTO rewards (name, description, type, value, expiry_date, image_url) 
VALUES ($1, $2, $3, $4, $5, $6);

-- READ ALL
SELECT * FROM rewards ORDER BY created_at;

-- READ BY ID
SELECT * FROM rewards WHERE id = $1;

-- READ BY TYPE
SELECT * FROM rewards WHERE type = $1;

-- UPDATE
UPDATE rewards 
SET name = $2, description = $3, type = $4, value = $5, expiry_date = $6, image_url = $7, updated_at = CURRENT_TIMESTAMP
WHERE id = $1;

-- DELETE
DELETE FROM rewards WHERE id = $1;

-- ============================================
-- USER REWARDS CRUD QUERIES
-- ============================================

-- CREATE (EARN)
INSERT INTO user_rewards (user_id, reward_id, event_id) 
VALUES ($1, $2, $3);

-- READ ALL BY USER
SELECT ur.*, r.name as reward_name, r.description, r.type, r.value, r.expiry_date 
FROM user_rewards ur
JOIN rewards r ON ur.reward_id = r.id
WHERE ur.user_id = $1
ORDER BY ur.earned_at DESC;

-- READ BY USER AND EVENT
SELECT ur.*, r.name as reward_name, r.description, r.type, r.value, r.expiry_date 
FROM user_rewards ur
JOIN rewards r ON ur.reward_id = r.id
WHERE ur.user_id = $1 AND ur.event_id = $2;

-- UPDATE (REDEEM)
UPDATE user_rewards 
SET is_redeemed = TRUE, redeemed_at = CURRENT_TIMESTAMP 
WHERE id = $1;

-- DELETE
DELETE FROM user_rewards WHERE id = $1;

-- ============================================
-- COLLECTIONS CRUD QUERIES
-- ============================================

-- CREATE
INSERT INTO collections (name, description, xp_reward, coin_reward, total_items, icon_url) 
VALUES ($1, $2, $3, $4, $5, $6);

-- READ ALL
SELECT * FROM collections ORDER BY xp_reward;

-- READ BY ID
SELECT * FROM collections WHERE id = $1;

-- UPDATE
UPDATE collections 
SET name = $2, description = $3, xp_reward = $4, coin_reward = $5, total_items = $6, icon_url = $7, updated_at = CURRENT_TIMESTAMP
WHERE id = $1;

-- DELETE
DELETE FROM collections WHERE id = $1;

-- ============================================
-- USER COLLECTIONS CRUD QUERIES
-- ============================================

-- CREATE (START)
INSERT INTO user_collections (user_id, collection_id) 
VALUES ($1, $2);

-- READ ALL BY USER
SELECT uc.*, c.name as collection_name, c.description, c.total_items 
FROM user_collections uc
JOIN collections c ON uc.collection_id = c.id
WHERE uc.user_id = $1
ORDER BY uc.started_at DESC;

-- UPDATE PROGRESS
UPDATE user_collections 
SET progress = $2 
WHERE user_id = $1 AND collection_id = $2;

-- COMPLETE
UPDATE user_collections 
SET is_completed = TRUE, completed_at = CURRENT_TIMESTAMP 
WHERE user_id = $1 AND collection_id = $2;

-- DELETE
DELETE FROM user_collections WHERE user_id = $1 AND collection_id = $2;

-- ============================================
-- FOOD TRUCKS CRUD QUERIES
-- ============================================

-- CREATE
INSERT INTO food_trucks (name, description, category, latitude, longitude, address, phone, opening_hours, image_url, rating, is_active) 
VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11);

-- READ ALL
SELECT * FROM food_trucks ORDER BY rating DESC;

-- READ ACTIVE
SELECT * FROM food_trucks WHERE is_active = TRUE ORDER BY rating DESC;

-- READ BY CATEGORY
SELECT * FROM food_trucks WHERE category = $1 AND is_active = TRUE ORDER BY rating DESC;

-- READ BY ID
SELECT * FROM food_trucks WHERE id = $1;

-- READ NEARBY (within radius in km)
SELECT *, 
    (6371 * acos(cos(radians($1)) * cos(radians(latitude)) * cos(radians(longitude) - radians($2)) + sin(radians($1)) * sin(radians(latitude)))) AS distance
FROM food_trucks
WHERE is_active = TRUE
HAVING distance < $3
ORDER BY distance;

-- UPDATE
UPDATE food_trucks 
SET name = $2, description = $3, category = $4, latitude = $5, longitude = $6, address = $7, phone = $8, opening_hours = $9, image_url = $10, rating = $11, is_active = $12, updated_at = CURRENT_TIMESTAMP
WHERE id = $1;

-- DELETE
DELETE FROM food_trucks WHERE id = $1;

-- ============================================
-- COLLECTIBLES CRUD QUERIES
-- ============================================

-- CREATE
INSERT INTO collectibles (name, description, rarity, xp_reward, coin_reward, food_truck_id, collection_id, type, image_url, is_available) 
VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10);

-- READ ALL
SELECT * FROM collectibles ORDER BY rarity, xp_reward;

-- READ AVAILABLE
SELECT * FROM collectibles WHERE is_available = TRUE ORDER BY rarity, xp_reward;

-- READ BY ID
SELECT * FROM collectibles WHERE id = $1;

-- READ BY FOOD TRUCK
SELECT * FROM collectibles WHERE food_truck_id = $1 AND is_available = TRUE;

-- READ BY COLLECTION
SELECT * FROM collectibles WHERE collection_id = $1 AND is_available = TRUE;

-- READ BY TYPE
SELECT * FROM collectibles WHERE type = $1 AND is_available = TRUE;

-- READ BY RARITY
SELECT * FROM collectibles WHERE rarity = $1 AND is_available = TRUE;

-- UPDATE
UPDATE collectibles 
SET name = $2, description = $3, rarity = $4, xp_reward = $5, coin_reward = $6, food_truck_id = $7, collection_id = $8, type = $9, image_url = $10, is_available = $11, updated_at = CURRENT_TIMESTAMP
WHERE id = $1;

-- DELETE
DELETE FROM collectibles WHERE id = $1;

-- ============================================
-- USER COLLECTIBLES CRUD QUERIES
-- ============================================

-- CREATE (COLLECT)
INSERT INTO user_collectibles (user_id, collectible_id) 
VALUES ($1, $2);

-- READ ALL BY USER
SELECT uc.*, c.name as collectible_name, c.description, c.rarity, c.xp_reward, c.coin_reward, c.image_url 
FROM user_collectibles uc
JOIN collectibles c ON uc.collectible_id = c.id
WHERE uc.user_id = $1
ORDER BY uc.collected_at DESC;

-- READ BY USER AND COLLECTIBLE
SELECT * FROM user_collectibles WHERE user_id = $1 AND collectible_id = $2;

-- READ USER INVENTORY WITH FILTERS
SELECT uc.*, c.name as collectible_name, c.description, c.rarity, c.xp_reward, c.coin_reward, c.image_url, ft.name as food_truck_name, ft.category
FROM user_collectibles uc
JOIN collectibles c ON uc.collectible_id = c.id
LEFT JOIN food_trucks ft ON c.food_truck_id = ft.id
WHERE uc.user_id = $1
AND ($2 = '' OR ft.category = $2)
AND ($3 = '' OR LOWER(c.name) LIKE LOWER('%' || $3 || '%'))
ORDER BY c.rarity, c.name;

-- DELETE
DELETE FROM user_collectibles WHERE user_id = $1 AND collectible_id = $2;

-- ============================================
-- AUDIT LOGS CRUD QUERIES
-- ============================================

-- CREATE
INSERT INTO audit_logs (username, action, entity_type, entity_id, ip_address, status, details) 
VALUES ($1, $2, $3, $4, $5, $6, $7);

-- READ ALL
SELECT * FROM audit_logs ORDER BY timestamp DESC;

-- READ BY USERNAME
SELECT * FROM audit_logs WHERE username = $1 ORDER BY timestamp DESC;

-- READ BY ACTION
SELECT * FROM audit_logs WHERE action = $1 ORDER BY timestamp DESC;

-- READ BY DATE RANGE
SELECT * FROM audit_logs 
WHERE timestamp BETWEEN $1 AND $2 
ORDER BY timestamp DESC;

-- DELETE BY DATE
DELETE FROM audit_logs WHERE timestamp < $1;

-- ============================================
-- COMPLEX QUERIES
-- ============================================

-- Get user statistics
SELECT 
    u.id,
    u.username,
    u.coins,
    u.xp,
    u.level,
    COUNT(DISTINCT uc.collectible_id) as total_collectibles,
    COUNT(DISTINCT ua.achievement_id) as total_achievements,
    COUNT(DISTINCT ur.id) as total_rewards,
    COUNT(DISTINCT ucol.collection_id) as total_collections_started,
    SUM(CASE WHEN ucol.is_completed = TRUE THEN 1 ELSE 0 END) as total_collections_completed
FROM users u
LEFT JOIN user_collectibles uc ON u.id = uc.user_id
LEFT JOIN user_achievements ua ON u.id = ua.user_id
LEFT JOIN user_rewards ur ON u.id = ur.user_id
LEFT JOIN user_collections ucol ON u.id = ucol.user_id
WHERE u.id = $1
GROUP BY u.id, u.username, u.coins, u.xp, u.level;

-- Get leaderboard
SELECT 
    u.id,
    u.username,
    u.xp,
    u.level,
    COUNT(DISTINCT uc.collectible_id) as collectibles_count,
    RANK() OVER (ORDER BY u.xp DESC) as rank
FROM users u
LEFT JOIN user_collectibles uc ON u.id = uc.user_id
GROUP BY u.id, u.username, u.xp, u.level
ORDER BY u.xp DESC
LIMIT 10;

-- Get collection progress for user
SELECT 
    c.id,
    c.name,
    c.description,
    c.total_items,
    uc.progress,
    uc.is_completed,
    uc.started_at,
    uc.completed_at,
    ROUND((uc.progress::float / c.total_items::float) * 100, 2) as completion_percentage
FROM collections c
LEFT JOIN user_collections uc ON c.id = uc.collection_id AND uc.user_id = $1
ORDER BY c.name;

-- Get available collectibles near location
SELECT 
    c.*,
    ft.name as food_truck_name,
    ft.category,
    ft.address,
    ft.opening_hours,
    (6371 * acos(cos(radians($1)) * cos(radians(ft.latitude)) * cos(radians(ft.longitude) - radians($2)) + sin(radians($1)) * sin(radians(ft.latitude)))) AS distance
FROM collectibles c
JOIN food_trucks ft ON c.food_truck_id = ft.id
WHERE c.is_available = TRUE
AND ft.is_active = TRUE
HAVING distance < $3
ORDER BY distance, c.rarity;

-- Get event statistics
SELECT 
    e.id,
    e.name,
    e.start_date,
    e.end_date,
    e.is_active,
    COUNT(DISTINCT uc.user_id) as participants,
    COUNT(DISTINCT uc.collectible_id) as collectibles_found
FROM events e
LEFT JOIN collectibles c ON c.food_truck_id IN (SELECT id FROM food_trucks WHERE is_active = TRUE)
LEFT JOIN user_collectibles uc ON c.id = uc.collectible_id
WHERE e.id = $1
GROUP BY e.id, e.name, e.start_date, e.end_date, e.is_active;

-- ============================================
-- END OF SCHEMA
-- ============================================
