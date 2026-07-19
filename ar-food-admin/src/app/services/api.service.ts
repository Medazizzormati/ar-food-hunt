import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class ApiService {
  private baseUrl = 'http://localhost:8080/api';
  
  constructor(private http: HttpClient) {}
  
  private getHeaders(includeAuth: boolean = true): HttpHeaders {
    let headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    
    if (includeAuth) {
      const token = localStorage.getItem('token');
      if (token) {
        headers = headers.set('Authorization', `Bearer ${token}`);
      }
    }
    
    return headers;
  }
  
  // Auth endpoints
  login(username: string, password: string): Observable<any> {
    return this.http.post(`${this.baseUrl}/auth/login`, 
      { username, password },
      { headers: this.getHeaders(false) }
    );
  }
  
  register(username: string, email: string, password: string): Observable<any> {
    return this.http.post(`${this.baseUrl}/auth/register`,
      { username, email, password },
      { headers: this.getHeaders(false) }
    );
  }
  
  logout() {
    localStorage.removeItem('token');
  }
  
  // User endpoints
  getUsers(): Observable<any> {
    return this.http.get(`${this.baseUrl}/users`, { headers: this.getHeaders() });
  }
  
  getUserById(id: number): Observable<any> {
    return this.http.get(`${this.baseUrl}/users/${id}`, { headers: this.getHeaders() });
  }
  
  updateUser(id: number, userData: any): Observable<any> {
    return this.http.put(`${this.baseUrl}/users/${id}`, userData, { headers: this.getHeaders() });
  }
  
  deleteUser(id: number): Observable<any> {
    return this.http.delete(`${this.baseUrl}/users/${id}`, { headers: this.getHeaders() });
  }
  
  addCoins(id: number, coins: number): Observable<any> {
    return this.http.post(`${this.baseUrl}/users/${id}/coins?coins=${coins}`, {}, { headers: this.getHeaders() });
  }
  
  addXP(id: number, xp: number): Observable<any> {
    return this.http.post(`${this.baseUrl}/users/${id}/xp?xp=${xp}`, {}, { headers: this.getHeaders() });
  }
  
  // Event endpoints
  getEvents(): Observable<any> {
    return this.http.get(`${this.baseUrl}/events`, { headers: this.getHeaders() });
  }
  
  getActiveEvents(): Observable<any> {
    return this.http.get(`${this.baseUrl}/events/active`, { headers: this.getHeaders() });
  }
  
  getInactiveEvents(): Observable<any> {
    return this.http.get(`${this.baseUrl}/events/inactive`, { headers: this.getHeaders() });
  }
  
  createEvent(eventData: any): Observable<any> {
    return this.http.post(`${this.baseUrl}/events`, eventData, { headers: this.getHeaders() });
  }
  
  updateEvent(id: number, eventData: any): Observable<any> {
    return this.http.put(`${this.baseUrl}/events/${id}`, eventData, { headers: this.getHeaders() });
  }
  
  activateEvent(id: number): Observable<any> {
    return this.http.post(`${this.baseUrl}/events/${id}/activate`, {}, { headers: this.getHeaders() });
  }
  
  deactivateEvent(id: number): Observable<any> {
    return this.http.post(`${this.baseUrl}/events/${id}/deactivate`, {}, { headers: this.getHeaders() });
  }
  
  deleteEvent(id: number): Observable<any> {
    return this.http.delete(`${this.baseUrl}/events/${id}`, { headers: this.getHeaders() });
  }
  
  // Achievement endpoints
  getAchievements(): Observable<any> {
    return this.http.get(`${this.baseUrl}/achievements`, { headers: this.getHeaders() });
  }
  
  createAchievement(achievementData: any): Observable<any> {
    return this.http.post(`${this.baseUrl}/achievements`, achievementData, { headers: this.getHeaders() });
  }
  
  updateAchievement(id: number, achievementData: any): Observable<any> {
    return this.http.put(`${this.baseUrl}/achievements/${id}`, achievementData, { headers: this.getHeaders() });
  }
  
  deleteAchievement(id: number): Observable<any> {
    return this.http.delete(`${this.baseUrl}/achievements/${id}`, { headers: this.getHeaders() });
  }
  
  // Reward endpoints
  getRewards(): Observable<any> {
    return this.http.get(`${this.baseUrl}/rewards`, { headers: this.getHeaders() });
  }
  
  getRewardsByUser(userId: number): Observable<any> {
    return this.http.get(`${this.baseUrl}/rewards/user/${userId}`, { headers: this.getHeaders() });
  }
  
  getRewardsByEvent(eventId: number): Observable<any> {
    return this.http.get(`${this.baseUrl}/rewards/event/${eventId}`, { headers: this.getHeaders() });
  }
  
  createReward(rewardData: any): Observable<any> {
    return this.http.post(`${this.baseUrl}/rewards`, rewardData, { headers: this.getHeaders() });
  }
  
  updateReward(id: number, rewardData: any): Observable<any> {
    return this.http.put(`${this.baseUrl}/rewards/${id}`, rewardData, { headers: this.getHeaders() });
  }
  
  deleteReward(id: number): Observable<any> {
    return this.http.delete(`${this.baseUrl}/rewards/${id}`, { headers: this.getHeaders() });
  }
  
  // Collection endpoints
  getCollections(): Observable<any> {
    return this.http.get(`${this.baseUrl}/collections`, { headers: this.getHeaders() });
  }
  
  getCollectionsByEvent(eventId: number): Observable<any> {
    return this.http.get(`${this.baseUrl}/collections/event/${eventId}`, { headers: this.getHeaders() });
  }
  
  createCollection(collectionData: any): Observable<any> {
    return this.http.post(`${this.baseUrl}/collections`, collectionData, { headers: this.getHeaders() });
  }
  
  updateCollection(id: number, collectionData: any): Observable<any> {
    return this.http.put(`${this.baseUrl}/collections/${id}`, collectionData, { headers: this.getHeaders() });
  }
  
  deleteCollection(id: number): Observable<any> {
    return this.http.delete(`${this.baseUrl}/collections/${id}`, { headers: this.getHeaders() });
  }
  
  // FoodTruck endpoints
  getFoodTrucks(): Observable<any> {
    return this.http.get(`${this.baseUrl}/foodtrucks`, { headers: this.getHeaders() });
  }
  
  getFoodTrucksByCategory(category: string): Observable<any> {
    return this.http.get(`${this.baseUrl}/foodtrucks/category/${category}`, { headers: this.getHeaders() });
  }
  
  createFoodTruck(foodTruckData: any): Observable<any> {
    return this.http.post(`${this.baseUrl}/foodtrucks`, foodTruckData, { headers: this.getHeaders() });
  }
  
  updateFoodTruck(id: number, foodTruckData: any): Observable<any> {
    return this.http.put(`${this.baseUrl}/foodtrucks/${id}`, foodTruckData, { headers: this.getHeaders() });
  }
  
  deleteFoodTruck(id: number): Observable<any> {
    return this.http.delete(`${this.baseUrl}/foodtrucks/${id}`, { headers: this.getHeaders() });
  }
  
  // Collectible endpoints
  getCollectibles(): Observable<any> {
    return this.http.get(`${this.baseUrl}/collectibles`, { headers: this.getHeaders() });
  }
  
  getAvailableCollectibles(): Observable<any> {
    return this.http.get(`${this.baseUrl}/collectibles/available`, { headers: this.getHeaders() });
  }
  
  getCollectiblesByFoodTruck(foodTruckId: number): Observable<any> {
    return this.http.get(`${this.baseUrl}/collectibles/foodtruck/${foodTruckId}`, { headers: this.getHeaders() });
  }
  
  createCollectible(collectibleData: any): Observable<any> {
    return this.http.post(`${this.baseUrl}/collectibles`, collectibleData, { headers: this.getHeaders() });
  }
  
  updateCollectible(id: number, collectibleData: any): Observable<any> {
    return this.http.put(`${this.baseUrl}/collectibles/${id}`, collectibleData, { headers: this.getHeaders() });
  }
  
  deleteCollectible(id: number): Observable<any> {
    return this.http.delete(`${this.baseUrl}/collectibles/${id}`, { headers: this.getHeaders() });
  }
}
