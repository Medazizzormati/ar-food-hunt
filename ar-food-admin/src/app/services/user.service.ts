import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';
import { ApiService } from './api.service';

export interface User {
  id: string;
  name: string;
  level: number;
  role: string;
  status: string;
  joined: string;
}

@Injectable({
  providedIn: 'root'
})
export class UserService {
  private usersSubject = new BehaviorSubject<User[]>([]);
  users$ = this.usersSubject.asObservable();

  constructor(private apiService: ApiService) {
    this.fetchUsers();
  }

  fetchUsers() {
    this.apiService.getUsers().subscribe((data: any[]) => {
      const users: User[] = data.map(u => ({
        id: u.id ? u.id.toString() : '',
        name: u.username || u.name || '',
        level: u.level || 1,
        role: u.role || 'Player',
        status: u.status || 'Active',
        joined: u.createdAt || u.joined || new Date().toISOString()
      }));
      this.usersSubject.next(users);
    });
  }

  getUsers(): User[] {
    return this.usersSubject.value;
  }

  addUser(user: Omit<User, 'id'>) {
    const payload = {
      username: user.name,
      email: `${user.name.replace(/\s+/g, '').toLowerCase()}@example.com`,
      password: 'password123',
      role: user.role,
      level: user.level,
      status: user.status
    };
    
    // Fallback to register since apiService has no create user (just register)
    this.apiService.register(payload.username, payload.email, payload.password).subscribe((newUser: any) => {
      const formattedUser = { ...user, id: newUser.id ? newUser.id.toString() : Math.random().toString(36).substring(2, 9), joined: new Date().toISOString() };
      this.usersSubject.next([...this.getUsers(), formattedUser]);
    });
  }

  updateUser(updatedUser: User) {
    const payload = {
      ...updatedUser,
      username: updatedUser.name
    };
    this.apiService.updateUser(Number(updatedUser.id), payload).subscribe(() => {
      const users = this.getUsers().map(u => u.id === updatedUser.id ? updatedUser : u);
      this.usersSubject.next(users);
    });
  }

  deleteUser(id: string) {
    this.apiService.deleteUser(Number(id)).subscribe(() => {
      const users = this.getUsers().filter(u => u.id !== id);
      this.usersSubject.next(users);
    });
  }
}
