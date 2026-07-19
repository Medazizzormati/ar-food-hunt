import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api';
  
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
  
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }
  
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
  
  static Map<String, String> _getHeaders({bool requireAuth = true}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    
    if (requireAuth) {
      final token = getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    
    return headers;
  }
  
  // Auth endpoints
  static Future<http.Response> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: _getHeaders(requireAuth: false),
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await saveToken(data['token']);
    }
    
    return response;
  }
  
  static Future<http.Response> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: _getHeaders(requireAuth: false),
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await saveToken(data['token']);
    }
    
    return response;
  }
  
  static Future<http.Response> logout() async {
    await clearToken();
    return http.Response('Logged out', 200);
  }
  
  // User endpoints
  static Future<http.Response> getUsers() async {
    return http.get(
      Uri.parse('$baseUrl/users'),
      headers: _getHeaders(),
    );
  }
  
  static Future<http.Response> getUserById(Long id) async {
    return http.get(
      Uri.parse('$baseUrl/users/$id'),
      headers: _getHeaders(),
    );
  }
  
  static Future<http.Response> updateUser(Long id, Map<String, dynamic> userData) async {
    return http.put(
      Uri.parse('$baseUrl/users/$id'),
      headers: _getHeaders(),
      body: jsonEncode(userData),
    );
  }
  
  static Future<http.Response> addCoins(Long id, int coins) async {
    return http.post(
      Uri.parse('$baseUrl/users/$id/coins?coins=$coins'),
      headers: _getHeaders(),
    );
  }
  
  static Future<http.Response> addXP(Long id, int xp) async {
    return http.post(
      Uri.parse('$baseUrl/users/$id/xp?xp=$xp'),
      headers: _getHeaders(),
    );
  }
  
  // Event endpoints
  static Future<http.Response> getEvents() async {
    return http.get(
      Uri.parse('$baseUrl/events'),
      headers: _getHeaders(),
    );
  }
  
  static Future<http.Response> getActiveEvents() async {
    return http.get(
      Uri.parse('$baseUrl/events/active'),
      headers: _getHeaders(),
    );
  }
  
  static Future<http.Response> createEvent(Map<String, dynamic> eventData) async {
    return http.post(
      Uri.parse('$baseUrl/events'),
      headers: _getHeaders(),
      body: jsonEncode(eventData),
    );
  }
  
  // Achievement endpoints
  static Future<http.Response> getAchievements() async {
    return http.get(
      Uri.parse('$baseUrl/achievements'),
      headers: _getHeaders(),
    );
  }
  
  static Future<http.Response> unlockAchievement(Long achievementId, Long userId) async {
    return http.post(
      Uri.parse('$baseUrl/achievements/$achievementId/unlock/$userId'),
      headers: _getHeaders(),
    );
  }
  
  // Reward endpoints
  static Future<http.Response> getRewardsByUser(Long userId) async {
    return http.get(
      Uri.parse('$baseUrl/rewards/user/$userId'),
      headers: _getHeaders(),
    );
  }
  
  static Future<http.Response> redeemReward(Long rewardId) async {
    return http.post(
      Uri.parse('$baseUrl/rewards/$rewardId/redeem'),
      headers: _getHeaders(),
    );
  }
  
  // Collection endpoints
  static Future<http.Response> getCollections() async {
    return http.get(
      Uri.parse('$baseUrl/collections'),
      headers: _getHeaders(),
    );
  }
  
  static Future<http.Response> completeCollection(Long collectionId, Long userId) async {
    return http.post(
      Uri.parse('$baseUrl/collections/$collectionId/complete/$userId'),
      headers: _getHeaders(),
    );
  }
  
  // FoodTruck endpoints
  static Future<http.Response> getFoodTrucks() async {
    return http.get(
      Uri.parse('$baseUrl/foodtrucks'),
      headers: _getHeaders(),
    );
  }
  
  static Future<http.Response> getFoodTrucksByCategory(String category) async {
    return http.get(
      Uri.parse('$baseUrl/foodtrucks/category/$category'),
      headers: _getHeaders(),
    );
  }
  
  // Collectible endpoints
  static Future<http.Response> getCollectibles() async {
    return http.get(
      Uri.parse('$baseUrl/collectibles'),
      headers: _getHeaders(),
    );
  }
  
  static Future<http.Response> getAvailableCollectibles() async {
    return http.get(
      Uri.parse('$baseUrl/collectibles/available'),
      headers: _getHeaders(),
    );
  }
  
  static Future<http.Response> collectCollectible(Long collectibleId, Long userId) async {
    return http.post(
      Uri.parse('$baseUrl/collectibles/$collectibleId/collect/$userId'),
      headers: _getHeaders(),
    );
  }
}

typedef Long = int;
