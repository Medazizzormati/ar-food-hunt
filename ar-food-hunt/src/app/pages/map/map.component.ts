import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';

interface FoodTruck {
  name: string;
  emoji: string;
  image: string;
  category: string;
  distance: string;
  items: number;
  status: string;
  badgeClass: string;
  event: string;
  x: number;
  y: number;
}

@Component({
  selector: 'app-map',
  standalone: true,
  imports: [CommonModule, RouterLink],
  templateUrl: './map.component.html',
  styleUrl: './map.component.scss'
})
export class MapComponent {
  filters = ['All', 'Burgers', 'Pizza', 'Dessert', 'Coffee', 'Tacos'];
  activeFilter = 'All';
  selectedTruck: FoodTruck | null = null;

  trucks: FoodTruck[] = [
    { name: 'Burger Bliss', emoji: '🍔', image: 'assets/images/burger_truck.png', category: 'Burgers & Fries', distance: '50m', items: 4, status: 'Active Event', badgeClass: 'badge-orange', event: '2× XP Active', x: 38, y: 28 },
    { name: 'Pizza Planet', emoji: '🍕', image: 'assets/images/pizza_truck.png', category: 'Italian Pizza', distance: '120m', items: 3, status: 'Open', badgeClass: 'badge-success', event: 'Normal drops', x: 62, y: 45 },
    { name: 'Ice Cream Van', emoji: '🍦', image: 'assets/images/ice_cream_truck.png', category: 'Ice Cream & Shakes', distance: '200m', items: 5, status: 'New Drops', badgeClass: 'badge-teal', event: 'Special drops', x: 28, y: 65 },
    { name: 'Taco Trek', emoji: '🌮', image: 'assets/images/taco_truck.png', category: 'Mexican Tacos', distance: '250m', items: 3, status: 'Open', badgeClass: 'badge-success', event: 'Normal drops', x: 72, y: 35 },
    { name: 'Coffee Co.', emoji: '☕', image: 'assets/images/burger_truck.png', category: 'Coffee & Drinks', distance: '310m', items: 2, status: 'Open', badgeClass: 'badge-success', event: 'Normal drops', x: 50, y: 58 },
    { name: 'Dessert Co.', emoji: '🧁', image: 'assets/images/ice_cream_truck.png', category: 'Desserts & Sweets', distance: '450m', items: 4, status: 'Closed', badgeClass: 'badge-danger', event: 'Reopens 6pm', x: 68, y: 72 },
  ];

  setFilter(f: string): void { this.activeFilter = f; }
  
  selectTruck(t: FoodTruck, event?: Event): void { 
    if (event) {
      event.stopPropagation();
    }
    this.selectedTruck = t; 
  }

  closeDetail(event?: Event): void {
    if (event) {
      event.stopPropagation();
    }
    this.selectedTruck = null;
  }
}
