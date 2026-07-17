import { Component, computed, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';

interface Item { name: string; emoji: string; rarity: 'common' | 'rare' | 'legendary'; xp: number; category: string; }

@Component({
  selector: 'app-inventory',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: './inventory.component.html',
  styleUrl: './inventory.component.scss'
})
export class InventoryComponent {
  categories = ['All', 'Burgers', 'Pizza', 'Dessert', 'Coffee', 'Special'];
  activeCategory = 'All';
  searchTerm = '';

  allItems: Item[] = [
    { name: 'Classic Burger', emoji: '🍔', rarity: 'common', xp: 50, category: 'Burgers' },
    { name: 'Golden Fries', emoji: '🍟', rarity: 'common', xp: 30, category: 'Burgers' },
    { name: 'Margherita', emoji: '🍕', rarity: 'common', xp: 45, category: 'Pizza' },
    { name: 'Golden Ticket', emoji: '🎟️', rarity: 'rare', xp: 200, category: 'Special' },
    { name: 'Ice Cream', emoji: '🍦', rarity: 'common', xp: 35, category: 'Dessert' },
    { name: 'Cold Brew', emoji: '☕', rarity: 'common', xp: 40, category: 'Coffee' },
    { name: 'Diamond', emoji: '💎', rarity: 'legendary', xp: 500, category: 'Special' },
    { name: 'Street Taco', emoji: '🌮', rarity: 'common', xp: 45, category: 'Burgers' },
    { name: 'Cupcake', emoji: '🧁', rarity: 'rare', xp: 150, category: 'Dessert' },
    { name: 'Magic Box', emoji: '📦', rarity: 'rare', xp: 180, category: 'Special' },
    { name: 'Milkshake', emoji: '🥤', rarity: 'common', xp: 35, category: 'Dessert' },
    { name: 'Festival Coin', emoji: '🪙', rarity: 'rare', xp: 120, category: 'Special' },
  ];

  get filteredItems(): Item[] {
    return this.allItems.filter(i =>
      (this.activeCategory === 'All' || i.category === this.activeCategory) &&
      i.name.toLowerCase().includes(this.searchTerm.toLowerCase())
    );
  }

  rarityBadge(rarity: string): string {
    return { common: 'badge-teal', rare: 'badge-gold', legendary: 'badge-purple' }[rarity] ?? 'badge-teal';
  }
}
