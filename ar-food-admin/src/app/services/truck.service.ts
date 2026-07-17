import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';

export interface Truck {
  id: string;
  name: string;
  owner: string;
  category: string;
  location: string;
  status: string;
}

@Injectable({
  providedIn: 'root'
})
export class TruckService {
  private initialTrucks: Truck[] = [
    { id: '1', name: 'Burger Bliss', owner: 'Mike T.', category: 'American', location: 'Central Park', status: 'Active' },
    { id: '2', name: 'Pizza Planet', owner: 'Luigi R.', category: 'Italian', location: 'Downtown', status: 'Active' },
    { id: '3', name: 'Taco Trek', owner: 'Carmen S.', category: 'Mexican', location: 'Westside', status: 'Suspended' },
    { id: '4', name: 'Vegan Vibes', owner: 'Zoe K.', category: 'Vegan', location: 'East Village', status: 'Pending Approval' }
  ];

  private trucksSubject = new BehaviorSubject<Truck[]>(this.initialTrucks);
  trucks$ = this.trucksSubject.asObservable();

  constructor() { }

  getTrucks(): Truck[] {
    return this.trucksSubject.value;
  }

  addTruck(truck: Omit<Truck, 'id'>) {
    const newTruck = { ...truck, id: Math.random().toString(36).substring(2, 9) };
    this.trucksSubject.next([...this.getTrucks(), newTruck]);
  }

  updateTruck(updatedTruck: Truck) {
    const trucks = this.getTrucks().map(t => t.id === updatedTruck.id ? updatedTruck : t);
    this.trucksSubject.next(trucks);
  }

  deleteTruck(id: string) {
    const trucks = this.getTrucks().filter(t => t.id !== id);
    this.trucksSubject.next(trucks);
  }
}
