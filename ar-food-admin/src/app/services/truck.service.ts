import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';
import { ApiService } from './api.service';

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
  private trucksSubject = new BehaviorSubject<Truck[]>([]);
  trucks$ = this.trucksSubject.asObservable();

  constructor(private apiService: ApiService) {
    this.fetchTrucks();
  }

  fetchTrucks() {
    this.apiService.getFoodTrucks().subscribe((data: any[]) => {
      const trucks: Truck[] = data.map(t => ({
        id: t.id ? t.id.toString() : '',
        name: t.name || t.truckName || '',
        owner: t.owner || '',
        category: t.category || '',
        location: t.location || '',
        status: t.status || 'Active'
      }));
      this.trucksSubject.next(trucks);
    });
  }

  getTrucks(): Truck[] {
    return this.trucksSubject.value;
  }

  addTruck(truck: Omit<Truck, 'id'>) {
    this.apiService.createFoodTruck(truck).subscribe((newTruck: any) => {
      const formattedTruck = { ...truck, id: newTruck.id ? newTruck.id.toString() : Math.random().toString(36).substring(2, 9) };
      this.trucksSubject.next([...this.getTrucks(), formattedTruck]);
    });
  }

  updateTruck(updatedTruck: Truck) {
    this.apiService.updateFoodTruck(Number(updatedTruck.id), updatedTruck).subscribe(() => {
      const trucks = this.getTrucks().map(t => t.id === updatedTruck.id ? updatedTruck : t);
      this.trucksSubject.next(trucks);
    });
  }

  deleteTruck(id: string) {
    this.apiService.deleteFoodTruck(Number(id)).subscribe(() => {
      const trucks = this.getTrucks().filter(t => t.id !== id);
      this.trucksSubject.next(trucks);
    });
  }
}
