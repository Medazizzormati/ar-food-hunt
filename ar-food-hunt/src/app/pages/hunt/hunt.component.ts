import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';

interface FoodTruck {
  name: string;
  emoji: string;
  distance: string;
  x: number;
  y: number;
  hasCollectibles: boolean;
}

@Component({
  selector: 'app-hunt',
  standalone: true,
  imports: [CommonModule, RouterLink],
  templateUrl: './hunt.component.html',
  styleUrl: './hunt.component.scss'
})
export class HuntComponent {
  viewMode: 'ar' | 'map' = 'ar';
  
  foodTrucks: FoodTruck[] = [
    { name: 'Burger Bliss', emoji: '🍔', distance: '50m', x: 30, y: 25, hasCollectibles: true },
    { name: 'Pizza Planet', emoji: '🍕', distance: '120m', x: 65, y: 45, hasCollectibles: true },
    { name: 'Taco Trek', emoji: '🌮', distance: '250m', x: 40, y: 65, hasCollectibles: true },
    { name: 'Ice Cream Van', emoji: '🍦', distance: '200m', x: 75, y: 30, hasCollectibles: false },
  ];

  toggleViewMode(mode: 'ar' | 'map') {
    this.viewMode = mode;
  }

  selectTruck(truck: FoodTruck) {
    console.log('Selected truck:', truck.name);
  }
}
