import { Component } from '@angular/core';
import { RouterOutlet, RouterLink, RouterLinkActive } from '@angular/router';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet, RouterLink, RouterLinkActive, CommonModule],
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss'
})
export class AppComponent {
  sidebarOpen = true;
  mobileMenuOpen = false;

  toggleSidebar(): void {
    this.sidebarOpen = !this.sidebarOpen;
  }

  toggleMobileMenu(): void {
    this.mobileMenuOpen = !this.mobileMenuOpen;
  }

  navItems = [
    { label: 'Home', icon: 'home', route: '/home' },
    { label: 'Explore', icon: 'map', route: '/explore' },
    { label: 'Hunt Mode', icon: 'camera', route: '/hunt', badge: 'LIVE' },
    { label: 'Inventory', icon: 'inventory_2', route: '/inventory' },
    { label: 'Collections', icon: 'collections_bookmark', route: '/collections' },
    { label: 'Rewards', icon: 'redeem', route: '/rewards' },
    { label: 'Leaderboard', icon: 'leaderboard', route: '/leaderboard' },
    { label: 'Profile', icon: 'person', route: '/profile' },
  ];

  isDarkMode = true;
  showNotifications = false;
  showSettings = false;
  profilePhoto = 'https://api.dicebear.com/7.x/avataaars/svg?seed=Felix&backgroundColor=FF7B00';

  toggleTheme() {
    this.isDarkMode = !this.isDarkMode;
    if (this.isDarkMode) {
      document.body.classList.remove('light-theme');
    } else {
      document.body.classList.add('light-theme');
    }
  }

  toggleNotifications() {
    this.showNotifications = !this.showNotifications;
    this.showSettings = false;
  }

  toggleSettings() {
    this.showSettings = !this.showSettings;
    this.showNotifications = false;
  }

  changeProfilePhoto() {
    const seeds = ['Felix', 'Alex', 'Sarah', 'Mia', 'John'];
    const randomSeed = seeds[Math.floor(Math.random() * seeds.length)];
    this.profilePhoto = `https://api.dicebear.com/7.x/avataaars/svg?seed=${randomSeed}&backgroundColor=06B6D4`;
  }
}
