import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';

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
  private initialUsers: User[] = [
    { id: '1', name: 'Alex Hunter', level: 42, role: 'Player', status: 'Active', joined: 'Oct 12, 2025' },
    { id: '2', name: 'Maria Garcia', level: 15, role: 'Player', status: 'Active', joined: 'Nov 01, 2025' },
    { id: '3', name: 'John Doe', level: 8, role: 'Player', status: 'Suspended', joined: 'Dec 05, 2025' },
    { id: '4', name: 'Sarah Connor', level: 99, role: 'Admin', status: 'Active', joined: 'Jan 01, 2024' },
    { id: '5', name: 'FoodieMaster99', level: 27, role: 'Player', status: 'Active', joined: 'Feb 14, 2026' }
  ];

  private usersSubject = new BehaviorSubject<User[]>(this.initialUsers);
  users$ = this.usersSubject.asObservable();

  constructor() { }

  getUsers(): User[] {
    return this.usersSubject.value;
  }

  addUser(user: Omit<User, 'id'>) {
    const newUser = { ...user, id: Math.random().toString(36).substring(2, 9) };
    this.usersSubject.next([...this.getUsers(), newUser]);
  }

  updateUser(updatedUser: User) {
    const users = this.getUsers().map(u => u.id === updatedUser.id ? updatedUser : u);
    this.usersSubject.next(users);
  }

  deleteUser(id: string) {
    const users = this.getUsers().filter(u => u.id !== id);
    this.usersSubject.next(users);
  }
}
