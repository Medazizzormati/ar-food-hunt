# AR Food Hunt - Backend API Documentation

## Base URL
```
http://localhost:8082/api
```

## Authentication
All endpoints (except `/api/auth/**`) require JWT token in Authorization header:
```
Authorization: Bearer <token>
```

---

## Authentication Endpoints

### Register User
**POST** `/api/auth/register`

**Request Body:**
```json
{
  "username": "string",
  "email": "string",
  "password": "string"
}
```

**Response:**
```json
{
  "token": "jwt_token_string",
  "userId": 1,
  "username": "string",
  "email": "string",
  "role": "USER"
}
```

### Login
**POST** `/api/auth/login`

**Request Body:**
```json
{
  "username": "string",
  "password": "string"
}
```

**Response:**
```json
{
  "token": "jwt_token_string",
  "userId": 1,
  "username": "string",
  "email": "string",
  "role": "USER"
}
```

---

## User Endpoints

### Get All Users
**GET** `/api/users`  
**Roles:** USER, MODERATOR, ADMIN

### Get User by ID
**GET** `/api/users/{id}`  
**Roles:** USER, MODERATOR, ADMIN

### Update User
**PUT** `/api/users/{id}`  
**Roles:** USER, MODERATOR, ADMIN

**Request Body:**
```json
{
  "username": "string",
  "email": "string",
  "password": "string",
  "role": "USER"
}
```

### Add Coins to User
**POST** `/api/users/{id}/coins`  
**Roles:** USER, MODERATOR, ADMIN

**Query Parameters:**
- `coins` (integer): Number of coins to add

### Add XP to User
**POST** `/api/users/{id}/xp`  
**Roles:** USER, MODERATOR, ADMIN

**Query Parameters:**
- `xp` (integer): Amount of XP to add

### Delete User
**DELETE** `/api/users/{id}`  
**Roles:** ADMIN

---

## Event Endpoints

### Get All Events
**GET** `/api/events`  
**Roles:** USER, MODERATOR, ADMIN

### Get Event by ID
**GET** `/api/events/{id}`  
**Roles:** USER, MODERATOR, ADMIN

### Create Event
**POST** `/api/events`  
**Roles:** ADMIN

**Request Body:**
```json
{
  "name": "string",
  "description": "string",
  "startDate": "2024-01-01T10:00:00",
  "endDate": "2024-01-01T22:00:00",
  "location": "string",
  "isActive": true
}
```

### Update Event
**PUT** `/api/events/{id}`  
**Roles:** ADMIN

### Activate Event
**POST** `/api/events/{id}/activate`  
**Roles:** ADMIN

### Deactivate Event
**POST** `/api/events/{id}/deactivate`  
**Roles:** ADMIN

### Delete Event
**DELETE** `/api/events/{id}`  
**Roles:** ADMIN

---

## Achievement Endpoints

### Get All Achievements
**GET** `/api/achievements`  
**Roles:** USER, MODERATOR, ADMIN

### Get Achievement by ID
**GET** `/api/achievements/{id}`  
**Roles:** USER, MODERATOR, ADMIN

### Create Achievement
**POST** `/api/achievements`  
**Roles:** ADMIN

**Request Body:**
```json
{
  "name": "string",
  "description": "string",
  "xpReward": 100,
  "coinReward": 50,
  "iconUrl": "string"
}
```

### Update Achievement
**PUT** `/api/achievements/{id}`  
**Roles:** ADMIN

### Delete Achievement
**DELETE** `/api/achievements/{id}`  
**Roles:** ADMIN

### Unlock Achievement
**POST** `/api/achievements/{id}/unlock/{userId}`  
**Roles:** USER, MODERATOR, ADMIN

---

## Reward Endpoints

### Get All Rewards
**GET** `/api/rewards`  
**Roles:** USER, MODERATOR, ADMIN

### Get Reward by ID
**GET** `/api/rewards/{id}`  
**Roles:** USER, MODERATOR, ADMIN

### Create Reward
**POST** `/api/rewards`  
**Roles:** ADMIN

**Request Body:**
```json
{
  "name": "string",
  "description": "string",
  "coinCost": 100,
  "iconUrl": "string"
}
```

### Update Reward
**PUT** `/api/rewards/{id}`  
**Roles:** ADMIN

### Delete Reward
**DELETE** `/api/rewards/{id}`  
**Roles:** ADMIN

### Redeem Reward
**POST** `/api/rewards/{id}/redeem`  
**Roles:** USER, MODERATOR, ADMIN

---

## Collection Endpoints

### Get All Collections
**GET** `/api/collections`  
**Roles:** USER, MODERATOR, ADMIN

### Get Collection by ID
**GET** `/api/collections/{id}`  
**Roles:** USER, MODERATOR, ADMIN

### Create Collection
**POST** `/api/collections`  
**Roles:** ADMIN

**Request Body:**
```json
{
  "name": "string",
  "description": "string",
  "xpReward": 200,
  "coinReward": 100,
  "totalItems": 10,
  "iconUrl": "string"
}
```

### Update Collection
**PUT** `/api/collections/{id}`  
**Roles:** ADMIN

### Delete Collection
**DELETE** `/api/collections/{id}`  
**Roles:** ADMIN

### Complete Collection
**POST** `/api/collections/{id}/complete/{userId}`  
**Roles:** USER, MODERATOR, ADMIN

---

## Food Truck Endpoints

### Get All Food Trucks
**GET** `/api/foodtrucks`  
**Roles:** USER, MODERATOR, ADMIN

### Get Food Truck by ID
**GET** `/api/foodtrucks/{id}`  
**Roles:** USER, MODERATOR, ADMIN

### Create Food Truck
**POST** `/api/foodtrucks`  
**Roles:** ADMIN

**Request Body:**
```json
{
  "name": "string",
  "description": "string",
  "category": "Burgers",
  "latitude": 40.7128,
  "longitude": -74.0060,
  "address": "string",
  "phone": "string",
  "openingHours": "string",
  "isActive": true
}
```

**Categories:** Burgers, Pizza, Dessert, Coffee, Asian, Mexican, Other

### Update Food Truck
**PUT** `/api/foodtrucks/{id}`  
**Roles:** ADMIN

### Delete Food Truck
**DELETE** `/api/foodtrucks/{id}`  
**Roles:** ADMIN

---

## Collectible Endpoints

### Get All Collectibles
**GET** `/api/collectibles`  
**Roles:** USER, MODERATOR, ADMIN

### Get Collectible by ID
**GET** `/api/collectibles/{id}`  
**Roles:** USER, MODERATOR, ADMIN

### Create Collectible
**POST** `/api/collectibles`  
**Roles:** ADMIN

**Request Body:**
```json
{
  "name": "string",
  "description": "string",
  "rarity": "Common",
  "foodTruckId": 1,
  "collectionId": 1,
  "emoji": "🍔",
  "isAvailable": true
}
```

**Rarities:** Common, Rare, Epic, Legendary

### Update Collectible
**PUT** `/api/collectibles/{id}`  
**Roles:** ADMIN

### Delete Collectible
**DELETE** `/api/collectibles/{id}`  
**Roles:** ADMIN

### Collect Item
**POST** `/api/collectibles/{id}/collect/{userId}`  
**Roles:** USER, MODERATOR, ADMIN

---

## Park Endpoints

### Get All Parks
**GET** `/api/parks`  
**Roles:** USER, MODERATOR, ADMIN

### Get Park by ID
**GET** `/api/parks/{id}`  
**Roles:** USER, MODERATOR, ADMIN

### Create Park
**POST** `/api/parks`  
**Roles:** ADMIN

**Request Body:**
```json
{
  "name": "string",
  "location": "string",
  "description": "string",
  "latitude": 40.7128,
  "longitude": -74.0060,
  "imageUrl": "string",
  "isActive": true
}
```

### Update Park
**PUT** `/api/parks/{id}`  
**Roles:** ADMIN

### Delete Park
**DELETE** `/api/parks/{id}`  
**Roles:** ADMIN

---

## Audit Endpoints

### Get All Audit Logs
**GET** `/api/audit`  
**Roles:** ADMIN

### Get Audit Logs by Username
**GET** `/api/audit/{username}`  
**Roles:** ADMIN

---

## Error Responses

### 401 Unauthorized
```json
{
  "error": "Unauthorized",
  "message": "Authentication required"
}
```

### 403 Forbidden
```json
{
  "error": "Forbidden",
  "message": "Insufficient permissions"
}
```

### 404 Not Found
```json
{
  "error": "Not Found",
  "message": "Resource not found"
}
```

### 429 Too Many Requests
```json
{
  "error": "Too Many Requests",
  "message": "Rate limit exceeded"
}
```

---

## Sample Users (from schema.sql)

**Admin:**
- Username: `admin`
- Password: `password` (BCrypt hash in database)

**Moderator:**
- Username: `moderator`
- Password: `password`

**Regular Users:**
- Username: `user1`
- Password: `password`

- Username: `user2`
- Password: `password`

---

## Testing with cURL

### Register new user:
```bash
curl -X POST http://localhost:8082/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser","email":"test@test.com","password":"password123"}'
```

### Login:
```bash
curl -X POST http://localhost:8082/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"password"}'
```

### Get events (with token):
```bash
curl -X GET http://localhost:8082/api/events \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

### Create event (admin only):
```bash
curl -X POST http://localhost:8082/api/events \
  -H "Authorization: Bearer ADMIN_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"name":"New Event","description":"Test event","startDate":"2024-08-01T10:00:00","endDate":"2024-08-01T22:00:00","location":"Test Location","isActive":true}'
```
