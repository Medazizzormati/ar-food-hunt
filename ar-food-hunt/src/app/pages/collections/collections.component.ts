import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-collections',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './collections.component.html',
  styleUrl: './collections.component.scss'
})
export class CollectionsComponent {
  collections = [
    {
      title: 'Burger Collection',
      icon: '🍔',
      collected: 4,
      total: 4,
      pct: 100,
      completed: true,
      reward: 'Burger Master Avatar',
      items: [
        { name: 'Classic', emoji: '🍔', collected: true },
        { name: 'Fries', emoji: '🍟', collected: true },
        { name: 'Shake', emoji: '🥤', collected: true },
        { name: 'Gold Bun', emoji: '🎟️', collected: true },
      ]
    },
    {
      title: 'Pizza Collection',
      icon: '🍕',
      collected: 2,
      total: 4,
      pct: 50,
      completed: false,
      reward: 'Pizza Planet Badge',
      items: [
        { name: 'Margherita', emoji: '🍕', collected: true },
        { name: 'Pepperoni', emoji: '🍕', collected: true },
        { name: 'Hawaiian', emoji: '🍍', collected: false },
        { name: 'BBQ', emoji: '🫕', collected: false },
      ]
    },
    {
      title: 'Dessert Collection',
      icon: '🍰',
      collected: 3,
      total: 5,
      pct: 60,
      completed: false,
      reward: 'Sweet Tooth Title',
      items: [
        { name: 'Cupcake', emoji: '🧁', collected: true },
        { name: 'Ice Cream', emoji: '🍦', collected: true },
        { name: 'Donut', emoji: '🍩', collected: true },
        { name: 'Macaroon', emoji: '🫐', collected: false },
        { name: 'Waffles', emoji: '🧇', collected: false },
      ]
    },
    {
      title: 'Festival Collection',
      icon: '🎉',
      collected: 0,
      total: 6,
      pct: 0,
      completed: false,
      reward: 'Festival Crown Avatar',
      items: [
        { name: 'Festival Coin', emoji: '🪙', collected: false },
        { name: 'Magic Box', emoji: '📦', collected: false },
        { name: 'Diamond', emoji: '💎', collected: false },
        { name: 'Star Token', emoji: '⭐', collected: false },
        { name: 'VIP Band', emoji: '🎫', collected: false },
        { name: 'Crown', emoji: '👑', collected: false },
      ]
    },
  ];
}
