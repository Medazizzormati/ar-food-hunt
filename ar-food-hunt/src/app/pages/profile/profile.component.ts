import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';

@Component({
  selector: 'app-profile',
  standalone: true,
  imports: [CommonModule, RouterLink],
  templateUrl: './profile.component.html',
  styleUrl: './profile.component.scss'
})
export class ProfileComponent {
  profilePhoto = 'https://api.dicebear.com/7.x/avataaars/svg?seed=Alex&backgroundColor=FF7B00';

  changeProfilePhoto() {
    const seeds = ['Felix', 'Alex', 'Sarah', 'Mia', 'John'];
    const randomSeed = seeds[Math.floor(Math.random() * seeds.length)];
    this.profilePhoto = `https://api.dicebear.com/7.x/avataaars/svg?seed=${randomSeed}&backgroundColor=FF7B00`;
  }

  heroStats = [
    { icon: '⭐', value: '850', label: 'XP' },
    { icon: '🪙', value: '1,250', label: 'Coins' },
    { icon: '🏆', value: '7', label: 'Badges' },
    { icon: '📦', value: '24', label: 'Items' },
  ];

  badges = [
    { name: 'Taco Taster', icon: '🌮', earned: true },
    { name: 'First Scan', icon: '📷', earned: true },
    { name: 'Burger Master', icon: '🍔', earned: true },
    { name: 'Coffee Hunter', icon: '☕', earned: false },
    { name: 'Explorer', icon: '🗺️', earned: false },
    { name: 'Champion', icon: '🏆', earned: false },
  ];

  visitedTrucks = [
    { name: 'Burger Bliss', emoji: '🍔', visits: 3, items: 8, date: 'Today' },
    { name: 'Taco Trek', emoji: '🌮', visits: 2, items: 5, date: 'Yesterday' },
    { name: 'Pizza Planet', emoji: '🍕', visits: 1, items: 3, date: 'Jul 12' },
    { name: 'Ice Cream Van', emoji: '🍦', visits: 1, items: 2, date: 'Jul 11' },
  ];

  settings = [
    { icon: 'notifications', label: 'Notifications', desc: 'Manage push alerts' },
    { icon: 'language', label: 'Language', desc: 'English (US)' },
    { icon: 'dark_mode', label: 'Dark Mode', desc: 'Currently enabled' },
    { icon: 'local_police', label: 'Privacy', desc: 'Location & data' },
    { icon: 'help', label: 'Help & Support', desc: 'FAQ & contact' },
    { icon: 'logout', label: 'Sign Out', desc: 'Log out of your account' },
  ];
}
