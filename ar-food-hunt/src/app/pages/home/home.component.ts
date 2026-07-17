import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [CommonModule, RouterLink],
  templateUrl: './home.component.html',
  styleUrl: './home.component.scss'
})
export class HomeComponent {
  missions = [
    { name: 'Visit 3 Food Trucks', icon: 'storefront', iconBg: 'var(--grad-orange)', current: 2, total: 3, pct: 67, reward: '50' },
    { name: 'Collect 5 Burgers', icon: 'lunch_dining', iconBg: 'var(--grad-teal)', current: 1, total: 5, pct: 20, reward: '100 XP' },
    { name: 'Complete Burger Set', icon: 'collections_bookmark', iconBg: 'var(--grad-purple)', current: 3, total: 4, pct: 75, reward: '200' },
    { name: 'Scan QR Coupon', icon: 'qr_code_scanner', iconBg: 'linear-gradient(135deg,#10B981,#059669)', current: 0, total: 1, pct: 0, reward: '30' },
  ];

  nearbyTrucks = [
    { name: 'Burger Bliss', emoji: '🍔', distance: '50m away', status: 'Active Event', badgeClass: 'badge-orange' },
    { name: 'Taco Trek', emoji: '🌮', distance: '120m away', status: 'Open', badgeClass: 'badge-success' },
    { name: 'Pizza Planet', emoji: '🍕', distance: '200m away', status: 'Open', badgeClass: 'badge-success' },
    { name: 'Ice Cream Van', emoji: '🍦', distance: '350m away', status: 'Closed', badgeClass: 'badge-danger' },
  ];

  activities = [
    { icon: '🍔', desc: 'Collected Classic Burger at Burger Bliss', time: '5 minutes ago' },
    { icon: '🎟️', desc: 'Found Golden Ticket! Rare drop!', time: '12 minutes ago' },
    { icon: '🏆', desc: 'Earned Burger Master badge', time: '1 hour ago' },
    { icon: '🌮', desc: 'Visited Taco Trek for the first time', time: '2 hours ago' },
    { icon: '🪙', desc: 'Redeemed 50 coins reward', time: '3 hours ago' },
  ];
}
