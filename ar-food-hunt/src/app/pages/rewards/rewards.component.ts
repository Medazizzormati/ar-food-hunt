import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-rewards',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './rewards.component.html',
  styleUrl: './rewards.component.scss'
})
export class RewardsComponent {
  tabs = ['Rewards', 'Coupons'];
  activeTab = 'Rewards';

  availableRewards = [
    { name: '20% OFF Burger Bliss', truck: 'Burger Bliss only', cost: 500,  icon: '🍔', type: 'Discount', badgeClass: 'badge-orange', accent: 'accent-orange', locked: false },
    { name: 'Free Taco',            truck: 'Taco Trek',         cost: 700,  icon: '🌮', type: 'Free Item', badgeClass: 'badge-teal',   accent: 'accent-teal',   locked: false },
    { name: 'Free Ice Cream',       truck: 'Any dessert truck',  cost: 800,  icon: '🍦', type: 'Free Item', badgeClass: 'badge-purple', accent: 'accent-purple', locked: false },
    { name: 'VIP Entry Pass',       truck: 'All food trucks',   cost: 2000, icon: '👑', type: 'VIP',      badgeClass: 'badge-gold',   accent: 'accent-gold',   locked: true  },
  ];

  coupons = [
    { title: '10% OFF Pizza Planet', sub: 'Burger Week Special deal', emoji: '🍕', expiry: 'Jul 20' },
    { title: 'Free Coffee',          sub: '5-truck mission reward',   emoji: '☕', expiry: 'Jul 18' },
    { title: 'BOGO Taco',            sub: 'Buy 1 get 1 free',         emoji: '🌮', expiry: 'Jul 22' },
  ];
}
