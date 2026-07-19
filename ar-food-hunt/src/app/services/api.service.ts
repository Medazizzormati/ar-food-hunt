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
  
  createEvent(eventData: any): Observable<any> {
    return this.http.post(`${this.baseUrl}/events`, eventData, { headers: this.getHeaders() });
  }
  
  // Achievement endpoints
  getAchievements(): Observable<any> {
    return this.http.get(`${this.baseUrl}/achievements`, { headers: this.getHeaders() });
  }
  
  unlockAchievement(achievementId: number, userId: number): Observable<any> {
    return this.http.post(`${this.baseUrl}/achievements/${achievementId}/unlock/${userId}`, {}, { headers: this.getHeaders() });
  }
  
  // Reward endpoints
  getRewardsByUser(userId: number): Observable<any> {
    return this.http.get(`${this.baseUrl}/rewards/user/${userId}`, { headers: this.getHeaders() });
  }
  
  redeemReward(rewardId: number): Observable<any> {
    return this.http.post(`${this.baseUrl}/rewards/${rewardId}/redeem`, {}, { headers: this.getHeaders() });
  }
  
  // Collection endpoints
  getCollections(): Observable<any> {
    return this.http.get(`${this.baseUrl}/collections`, { headers: this.getHeaders() });
  }
  
  completeCollection(collectionId: number, userId: number): Observable<any> {
    return this.http.post(`${this.baseUrl}/collections/${collectionId}/complete/${userId}`, {}, { headers: this.getHeaders() });
  }
  
  // FoodTruck endpoints
  getFoodTrucks(): Observable<any> {
    return this.http.get(`${this.baseUrl}/foodtrucks`, { headers: this.getHeaders() });
  }
  
  getFoodTrucksByCategory(category: string): Observable<any> {
    return this.http.get(`${this.baseUrl}/foodtrucks/category/${category}`, { headers: this.getHeaders() });
  }
  
  // Collectible endpoints
  getCollectibles(): Observable<any> {
    return this.http.get(`${this.baseUrl}/collectibles`, { headers: this.getHeaders() });
  }
  
  getAvailableCollectibles(): Observable<any> {
    return this.http.get(`${this.baseUrl}/collectibles/available`, { headers: this.getHeaders() });
  }
  
  collectCollectible(collectibleId: number, userId: number): Observable<any> {
    return this.http.post(`${this.baseUrl}/collectibles/${collectibleId}/collect/${userId}`, {}, { headers: this.getHeaders() });
  }
}
