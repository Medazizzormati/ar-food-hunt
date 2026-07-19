# AR Food Hunt

A Full Stack Graduation Project - An Augmented Reality (AR) food hunting game where users can discover collectibles at food trucks, complete collections, earn achievements, and unlock rewards.

## 📋 Table of Contents

- [Project Overview](#project-overview)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Features](#features)
- [Technologies](#technologies)
- [Setup Instructions](#setup-instructions)
- [API Documentation](#api-documentation)
- [Security Features](#security-features)
- [Usage Guide](#usage-guide)
- [Development Guidelines](#development-guidelines)

## Project Overview

AR Food Hunt is a gamified mobile application that combines augmented reality with food discovery. Users can:

- **Explore** food trucks in their area using AR
- **Collect** virtual items at real-world food truck locations
- **Complete** themed collections to earn rewards
- **Unlock** achievements through gameplay
- **Earn** XP, coins, and level up their profile
- **Redeem** rewards for real-world benefits

The project consists of three main components:
1. **Flutter Mobile App** - User-facing mobile application
2. **Angular Web Apps** - Admin dashboard and user web interface
3. **Spring Boot Backend** - RESTful API with comprehensive security

## Architecture

### Backend Architecture (Spring Boot - MVC Pattern)

The backend follows a strict Model-View-Controller (MVC) architecture with layered security:

```
┌─────────────────────────────────────────────────────────────┐
│                     Controller Layer                          │
│  (REST Endpoints, Validation, Authorization, Audit Logging) │
└──────────────────────┬──────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────────┐
│                      DTO Layer                               │
│  (Data Transfer Objects with Jakarta Validation)             │
└──────────────────────┬──────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────────┐
│                     Mapper Layer                             │
│  (Entity ↔ DTO Conversion)                                  │
└──────────────────────┬──────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────────┐
│                    Service Layer                             │
│  (Business Logic, Transaction Management)                   │
└──────────────────────┬──────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────────┐
│                   Repository Layer                           │
│  (JPA/Hibernate Data Access)                                │
└──────────────────────┬──────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────────┐
│                     Entity Layer                             │
│  (Database Models with JPA Annotations)                     │
└──────────────────────┬──────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────────┐
│                   PostgreSQL Database                        │
└─────────────────────────────────────────────────────────────┘
```

### Security Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Security Layer                            │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Rate Limiting Filter (100 req/min per IP)            │  │
│  └──────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  JWT Authentication Filter                            │  │
│  └──────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Role-Based Access Control (RBAC)                     │  │
│  │  - USER, MODERATOR, ADMIN                             │  │
│  └──────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Audit Logging (AOP)                                  │  │
│  └──────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Global Exception Handling                           │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## Project Structure

```
ar_food/
├── ar-food-backend/              # Spring Boot Backend
│   ├── src/main/java/com/arfood/
│   │   ├── annotation/           # Custom annotations (@Auditable)
│   │   ├── aspect/               # AOP aspects (AuditAspect)
│   │   ├── controller/           # REST controllers
│   │   ├── dto/                  # Data Transfer Objects
│   │   ├── entity/               # JPA entities
│   │   ├── enums/                # Enumerations (Role, RewardType, etc.)
│   │   ├── exception/            # Custom exceptions & handlers
│   │   ├── mapper/               # Entity-DTO mappers
│   │   ├── repository/           # JPA repositories
│   │   ├── security/             # Security configuration
│   │   └── service/              # Business logic services
│   ├── src/main/resources/
│   │   └── application.properties # Configuration
│   └── pom.xml                   # Maven dependencies
│
├── ar_food_flutter/              # Flutter Mobile App
│   ├── lib/
│   │   ├── models/               # Dart models
│   │   ├── services/             # API services
│   │   └── ...
│   └── pubspec.yaml              # Flutter dependencies
│
├── ar-food-hunt/                 # Angular User Web App
│   ├── src/app/
│   │   ├── models/               # TypeScript models
│   │   ├── services/             # API services
│   │   └── ...
│   └── package.json             # Angular dependencies
│
└── ar-food-admin/                # Angular Admin Dashboard
    ├── src/app/
    │   ├── models/               # TypeScript models
    │   ├── services/             # API services
    │   └── ...
    └── package.json             # Angular dependencies
```

## Features

### Backend Features

#### Core Functionality
- **User Management**: Registration, authentication, profile management
- **Event System**: Create, manage, and activate/deactivate events
- **Achievement System**: Define achievements and unlock them for users
- **Reward System**: Create rewards, assign to users, redemption tracking
- **Collection System**: Themed collections with completion rewards
- **Food Truck Management**: Manage food truck locations and categories
- **Collectible System**: AR collectibles at food truck locations

#### Security Features
- **JWT Authentication**: Token-based authentication with configurable expiration
- **Role-Based Access Control (RBAC)**: Three-tier permission system
  - **USER**: Read access, collect items, complete collections, unlock achievements
  - **MODERATOR**: Event management, user moderation
  - **ADMIN**: Full CRUD access on all resources
- **Rate Limiting**: 100 requests per minute per IP address
- **Input Validation**: Jakarta Validation with custom error messages
- **Password Security**: BCrypt encryption with complexity requirements
- **Audit Logging**: Comprehensive logging of all sensitive operations
- **Global Exception Handling**: Structured error responses
- **CORS Configuration**: Cross-origin resource sharing for frontend apps

#### Data Validation
- Email format validation
- Password complexity (8+ chars, uppercase, lowercase, digit, special char)
- Username length (3-50 characters)
- Positive value validation for XP, coins, rewards
- Size limits on text fields

### Frontend Features

#### Flutter Mobile App
- HTTP client integration with backend APIs
- JSON serialization/deserialization
- JWT token storage with SharedPreferences
- Models for User, Event, Collectible, FoodTruck
- Complete API service layer

#### Angular Web Apps
- HTTP client with interceptors
- TypeScript models matching backend entities
- JWT token management
- API service layer for all endpoints
- Admin-specific endpoints for ar-food-admin

## Technologies

### Backend
- **Spring Boot 3.2** - Application framework
- **Spring Security 6** - Security framework
- **Spring Data JPA** - Data access layer
- **PostgreSQL** - Relational database
- **Hibernate** - ORM framework
- **JWT (io.jsonwebtoken)** - Token-based authentication
- **Lombok** - Code generation
- **Jakarta Validation** - Input validation
- **Maven** - Dependency management

### Frontend
- **Flutter** - Mobile app framework
- **Angular 17** - Web framework
- **TypeScript** - Type-safe JavaScript
- **RxJS** - Reactive programming
- **HTTP Client** - REST API communication

## Setup Instructions

### Prerequisites

- Java 17 or higher
- Maven 3.6+
- PostgreSQL 12+
- Flutter 3.0+
- Node.js 18+
- Angular CLI 17+

### Database Setup

1. **Install PostgreSQL** and create a database:

```sql
CREATE DATABASE ar_food_hunt;
CREATE USER postgres WITH PASSWORD 'postgres';
GRANT ALL PRIVILEGES ON DATABASE ar_food_hunt TO postgres;
```

2. **Configure database connection** in `ar-food-backend/src/main/resources/application.properties`:

```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/ar_food_hunt
spring.datasource.username=postgres
spring.datasource.password=postgres
```

### Backend Setup

1. **Navigate to the backend directory**:

```bash
cd ar-food-backend
```

2. **Build the project**:

```bash
mvn clean install
```

3. **Run the application**:

```bash
mvn spring-boot:run
```

The backend will start on `http://localhost:8080`

### Flutter App Setup

1. **Navigate to the Flutter directory**:

```bash
cd ar_food_flutter
```

2. **Install dependencies**:

```bash
flutter pub get
```

3. **Run the app**:

```bash
flutter run
```

### Angular Web Apps Setup

#### ar-food-hunt (User Web App)

1. **Navigate to the directory**:

```bash
cd ar-food-hunt
```

2. **Install dependencies**:

```bash
npm install
```

3. **Run the development server**:

```bash
ng serve
```

The app will be available at `http://localhost:4200`

#### ar-food-admin (Admin Dashboard)

1. **Navigate to the directory**:

```bash
cd ar-food-admin
```

2. **Install dependencies**:

```bash
npm install
```

3. **Run the development server**:

```bash
ng serve
```

The admin dashboard will be available at `http://localhost:4201`

## API Documentation

### Base URL
```
http://localhost:8080/api
```

### Authentication Endpoints

#### Register User
```http
POST /api/auth/register
Content-Type: application/json

{
  "username": "john_doe",
  "email": "john@example.com",
  "password": "SecurePass123!"
}
```

#### Login
```http
POST /api/auth/login
Content-Type: application/json

{
  "username": "john_doe",
  "password": "SecurePass123!"
}
```

**Response:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "type": "Bearer",
  "userId": 1,
  "username": "john_doe",
  "email": "john@example.com",
  "role": "USER"
}
```

### User Endpoints (Admin Only)

#### Get All Users
```http
GET /api/users
Authorization: Bearer {token}
```

#### Get User by ID
```http
GET /api/users/{id}
Authorization: Bearer {token}
```

#### Update User
```http
PUT /api/users/{id}
Authorization: Bearer {token}
Content-Type: application/json

{
  "username": "john_doe_updated",
  "email": "john.updated@example.com"
}
```

#### Delete User
```http
DELETE /api/users/{id}
Authorization: Bearer {token}
```

#### Add Coins to User
```http
POST /api/users/{id}/coins?coins=100
Authorization: Bearer {token}
```

#### Add XP to User
```http
POST /api/users/{id}/xp?xp=50
Authorization: Bearer {token}
```

### Event Endpoints

#### Get All Events
```http
GET /api/events
Authorization: Bearer {token}
```

#### Get Active Events
```http
GET /api/events/active
Authorization: Bearer {token}
```

#### Get Event by ID
```http
GET /api/events/{id}
Authorization: Bearer {token}
```

#### Create Event (Moderator/Admin)
```http
POST /api/events
Authorization: Bearer {token}
Content-Type: application/json

{
  "name": "Summer Food Festival",
  "startDate": "2024-06-01T00:00:00",
  "endDate": "2024-08-31T23:59:59",
  "active": true
}
```

#### Update Event (Moderator/Admin)
```http
PUT /api/events/{id}
Authorization: Bearer {token}
Content-Type: application/json

{
  "name": "Updated Event Name",
  "active": false
}
```

#### Activate Event (Moderator/Admin)
```http
POST /api/events/{id}/activate
Authorization: Bearer {token}
```

#### Deactivate Event (Moderator/Admin)
```http
POST /api/events/{id}/deactivate
Authorization: Bearer {token}
```

#### Delete Event (Moderator/Admin)
```http
DELETE /api/events/{id}
Authorization: Bearer {token}
```

### Achievement Endpoints

#### Get All Achievements
```http
GET /api/achievements
Authorization: Bearer {token}
```

#### Get Achievement by ID
```http
GET /api/achievements/{id}
Authorization: Bearer {token}
```

#### Create Achievement (Admin)
```http
POST /api/achievements
Authorization: Bearer {token}
Content-Type: application/json

{
  "title": "First Collection",
  "description": "Complete your first collection",
  "icon": "trophy.png",
  "xpReward": 100
}
```

#### Update Achievement (Admin)
```http
PUT /api/achievements/{id}
Authorization: Bearer {token}
Content-Type: application/json

{
  "title": "Updated Title",
  "xpReward": 150
}
```

#### Unlock Achievement for User
```http
POST /api/achievements/{achievementId}/unlock/{userId}
Authorization: Bearer {token}
```

#### Delete Achievement (Admin)
```http
DELETE /api/achievements/{id}
Authorization: Bearer {token}
```

### Reward Endpoints

#### Get All Rewards
```http
GET /api/rewards
Authorization: Bearer {token}
```

#### Get Rewards by User
```http
GET /api/rewards/user/{userId}
Authorization: Bearer {token}
```

#### Get Reward by ID
```http
GET /api/rewards/{id}
Authorization: Bearer {token}
```

#### Create Reward (Admin)
```http
POST /api/rewards
Authorization: Bearer {token}
Content-Type: application/json

{
  "title": "Free Meal Coupon",
  "type": "COUPON",
  "value": "FREE_MEAL_2024",
  "userId": 1
}
```

#### Update Reward (Admin)
```http
PUT /api/rewards/{id}
Authorization: Bearer {token}
Content-Type: application/json

{
  "title": "Updated Reward",
  "type": "DISCOUNT"
}
```

#### Redeem Reward
```http
POST /api/rewards/{id}/redeem
Authorization: Bearer {token}
```

#### Delete Reward (Admin)
```http
DELETE /api/rewards/{id}
Authorization: Bearer {token}
```

### Collection Endpoints

#### Get All Collections
```http
GET /api/collections
Authorization: Bearer {token}
```

#### Get Collection by ID
```http
GET /api/collections/{id}
Authorization: Bearer {token}
```

#### Create Collection (Admin)
```http
POST /api/collections
Authorization: Bearer {token}
Content-Type: application/json

{
  "title": "Summer Collection",
  "rewardXP": 500,
  "rewardCoins": 100,
  "eventId": 1
}
```

#### Update Collection (Admin)
```http
PUT /api/collections/{id}
Authorization: Bearer {token}
Content-Type: application/json

{
  "title": "Updated Collection",
  "rewardXP": 600
}
```

#### Complete Collection for User
```http
POST /api/collections/{collectionId}/complete/{userId}
Authorization: Bearer {token}
```

#### Delete Collection (Admin)
```http
DELETE /api/collections/{id}
Authorization: Bearer {token}
```

### Food Truck Endpoints

#### Get All Food Trucks
```http
GET /api/foodtrucks
Authorization: Bearer {token}
```

#### Get Food Trucks by Category
```http
GET /api/foodtrucks/category/{category}
Authorization: Bearer {token}
```

#### Get Food Truck by ID
```http
GET /api/foodtrucks/{id}
Authorization: Bearer {token}
```

#### Create Food Truck (Admin)
```http
POST /api/foodtrucks
Authorization: Bearer {token}
Content-Type: application/json

{
  "name": "Taco Truck",
  "category": "Mexican",
  "latitude": 40.7128,
  "longitude": -74.0060,
  "description": "Authentic Mexican street food"
}
```

#### Update Food Truck (Admin)
```http
PUT /api/foodtrucks/{id}
Authorization: Bearer {token}
Content-Type: application/json

{
  "name": "Updated Truck Name",
  "category": "Updated Category"
}
```

#### Delete Food Truck (Admin)
```http
DELETE /api/foodtrucks/{id}
Authorization: Bearer {token}
```

### Collectible Endpoints

#### Get All Collectibles
```http
GET /api/collectibles
Authorization: Bearer {token}
```

#### Get Available Collectibles
```http
GET /api/collectibles/available
Authorization: Bearer {token}
```

#### Get Collectibles by Food Truck
```http
GET /api/collectibles/foodtruck/{foodTruckId}
Authorization: Bearer {token}
```

#### Get Collectible by ID
```http
GET /api/collectibles/{id}
Authorization: Bearer {token}
```

#### Create Collectible (Admin)
```http
POST /api/collectibles
Authorization: Bearer {token}
Content-Type: application/json

{
  "name": "Golden Taco",
  "model3D": "taco.glb",
  "type": "RARE",
  "xpReward": 50,
  "coinReward": 25,
  "latitude": 40.7128,
  "longitude": -74.0060,
  "available": true,
  "foodTruckId": 1
}
```

#### Update Collectible (Admin)
```http
PUT /api/collectibles/{id}
Authorization: Bearer {token}
Content-Type: application/json

{
  "name": "Updated Collectible",
  "xpReward": 75
}
```

#### Collect Collectible for User
```http
POST /api/collectibles/{collectibleId}/collect/{userId}
Authorization: Bearer {token}
```

#### Delete Collectible (Admin)
```http
DELETE /api/collectibles/{id}
Authorization: Bearer {token}
```

## Security Features

### Authentication Flow

1. **Registration**: User provides username, email, and password
2. **Password Encryption**: Password is encrypted using BCrypt
3. **Token Generation**: JWT token is generated upon successful login
4. **Token Validation**: JWT filter validates tokens on each request
5. **User Context**: Security context is set with user details

### Authorization Matrix

| Endpoint | USER | MODERATOR | ADMIN |
|----------|------|-----------|-------|
| GET /api/events | ✅ | ✅ | ✅ |
| POST /api/events | ❌ | ✅ | ✅ |
| PUT /api/events | ❌ | ✅ | ✅ |
| DELETE /api/events | ❌ | ✅ | ✅ |
| GET /api/users/{id} | ✅ | ✅ | ✅ |
| GET /api/users | ❌ | ❌ | ✅ |
| POST /api/achievements | ❌ | ❌ | ✅ |
| POST /api/rewards | ❌ | ❌ | ✅ |
| POST /api/collectibles/*/collect | ✅ | ✅ | ✅ |

### Rate Limiting

- **Default**: 100 requests per minute per IP address
- **Window**: 60 seconds sliding window
- **Response**: HTTP 429 when limit exceeded

### Audit Logging

All sensitive operations are logged with:
- Username
- Action performed
- Resource affected
- IP address
- Timestamp
- Success/Failure status

### Error Handling

Structured error responses:

```json
{
  "status": 404,
  "error": "Not Found",
  "message": "User not found with id: 123",
  "details": [],
  "timestamp": "2024-01-15T10:30:00",
  "path": "/api/users/123"
}
```

## Usage Guide

### For Users

1. **Register** an account using the mobile app or web interface
2. **Login** with your credentials to receive a JWT token
3. **Explore** food trucks in your area using the AR view
4. **Collect** virtual items at food truck locations
5. **Complete** collections to earn XP and coins
6. **Unlock** achievements by reaching milestones
7. **Redeem** rewards for real-world benefits

### For Moderators

1. **Login** with moderator credentials
2. **Manage** events (create, activate, deactivate)
3. **Monitor** user activity through audit logs
4. **Assist** users with account issues

### For Administrators

1. **Login** with admin credentials
2. **Manage** all resources (users, events, achievements, rewards, etc.)
3. **Configure** system settings
4. **Review** audit logs for security monitoring
5. **Assign** roles to users

## Development Guidelines

### Backend Development

1. **Follow MVC Pattern**: Keep controllers thin, business logic in services
2. **Use DTOs**: Never expose entities directly to clients
3. **Validate Input**: Always use @Valid on controller methods
4. **Handle Exceptions**: Use custom exceptions for specific error cases
5. **Add Audit Logging**: Use @Auditable on sensitive operations
6. **Secure Endpoints**: Always specify role requirements with @PreAuthorize
7. **Write Tests**: Unit tests for services, integration tests for controllers

### Frontend Development

1. **Use TypeScript**: Maintain type safety
2. **Handle Errors**: Implement proper error handling for API calls
3. **Store Tokens Securely**: Use secure storage for JWT tokens
4. **Refresh Tokens**: Implement token refresh logic
5. **Optimize Performance**: Use lazy loading for large datasets

### Code Style

- **Java**: Follow Google Java Style Guide
- **Dart**: Follow Effective Dart guidelines
- **TypeScript**: Follow TypeScript style guide
- **Comments**: Document public APIs and complex logic

## Configuration

### Backend Configuration

Edit `ar-food-backend/src/main/resources/application.properties`:

```properties
# Server Configuration
server.port=8080

# Database Configuration
spring.datasource.url=jdbc:postgresql://localhost:5432/ar_food_hunt
spring.datasource.username=postgres
spring.datasource.password=postgres

# JWT Configuration
jwt.secret=your-secret-key-here
jwt.expiration=86400000

# Rate Limiting
rate.limit.requests=100
rate.limit.window=60000

# CORS
cors.allowed-origins=http://localhost:4200,http://localhost:3000

# Logging
logging.level.com.arfood=DEBUG
logging.level.org.springframework.security=DEBUG
```

## Troubleshooting

### Common Issues

**Database Connection Failed**
- Ensure PostgreSQL is running
- Check database credentials in application.properties
- Verify database exists

**JWT Token Invalid**
- Check token expiration time
- Verify JWT secret matches between generation and validation
- Ensure token is sent in Authorization header: `Bearer {token}`

**Rate Limit Exceeded**
- Wait for the rate limit window to reset
- Adjust rate limit configuration if needed
- Check for API abuse patterns

**CORS Errors**
- Verify CORS configuration in SecurityConfig
- Check allowed origins in application.properties
- Ensure frontend URL is in allowed origins list

## License

This project is a graduation project for academic purposes.

## Contact

For questions or support, please contact the development team.

---

**Note**: This project uses production-ready security practices. Ensure you:
- Change default passwords and secrets in production
- Use environment variables for sensitive configuration
- Enable HTTPS in production
- Regularly update dependencies
- Implement proper backup strategies
