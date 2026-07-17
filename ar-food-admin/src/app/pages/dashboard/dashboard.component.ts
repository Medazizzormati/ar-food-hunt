import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './dashboard.component.html',
  styleUrl: './dashboard.component.scss'
})
export class DashboardComponent {
  activities = [
    { icon: 'qr_code_scanner', user: 'Alex H.', action: 'scanned a code at', target: 'Burger Bliss', time: 'Just now', colorClass: 'bg-orange' },
    { icon: 'workspace_premium', user: 'Sarah C.', action: 'unlocked the badge', target: 'Pizza Master', time: '2 mins ago', colorClass: 'bg-purple' },
    { icon: 'local_activity', user: 'Mike T.', action: 'redeemed a 20% coupon at', target: 'Taco Trek', time: '15 mins ago', colorClass: 'bg-success' },
    { icon: 'storefront', user: 'System', action: 'added a new food truck:', target: 'Dessert Co.', time: '1 hour ago', colorClass: 'bg-info' },
    { icon: 'group_add', user: 'System', action: 'registered', target: '142 new players', time: 'Today', colorClass: 'bg-orange' },
  ];

  topTrucks = [
    { name: 'Burger Bliss', emoji: '🍔', category: 'American', location: 'Central Park', scans: 12450, event: 'Summer Burger Week', status: 'Active' },
    { name: 'Pizza Planet', emoji: '🍕', category: 'Italian', location: 'Downtown Square', scans: 9820, event: '', status: 'Active' },
    { name: 'Taco Trek', emoji: '🌮', category: 'Mexican', location: 'Westside Market', scans: 8750, event: 'Taco Tuesday', status: 'Active' },
    { name: 'Ice Cream Van', emoji: '🍦', category: 'Dessert', location: 'Beach Boardwalk', scans: 6430, event: '', status: 'Offline' },
    { name: 'Coffee Co.', emoji: '☕', category: 'Cafe', location: 'Business District', scans: 5120, event: 'Morning Rush', status: 'Active' },
  ];
}
