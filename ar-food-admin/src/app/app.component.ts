import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterOutlet, RouterLink, RouterLinkActive } from '@angular/router';
import { MatMenuModule } from '@angular/material/menu';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatDialog, MatDialogModule } from '@angular/material/dialog';
import { MatSnackBar, MatSnackBarModule } from '@angular/material/snack-bar';
import { MatDividerModule } from '@angular/material/divider';
import { EventService } from './services/event.service';
import { EventDialogComponent } from './pages/events/event-dialog/event-dialog.component';
import { ConfirmDialogComponent } from './shared/confirm-dialog/confirm-dialog.component';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule, RouterOutlet, RouterLink, RouterLinkActive, MatMenuModule, MatButtonModule, MatIconModule, MatDialogModule, MatSnackBarModule, MatDividerModule],
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss'
})
export class AppComponent implements OnInit {
  title = 'ar-food-admin';
  mobileMenuOpen = false;
  isLightTheme = false;
  hasUnreadNotifications = true;
  showNotifications = false;

  notifications = [
    { title: 'New Truck Registration', message: 'Vegan Vibes is pending approval.', time: '5m ago', unread: true, icon: 'local_shipping', color: 'orange' },
    { title: 'Server Alert', message: 'High load detected on AR services.', time: '1h ago', unread: true, icon: 'warning', color: 'red' },
    { title: 'User Report', message: 'John Doe was reported for spam.', time: '2h ago', unread: false, icon: 'person', color: 'blue' }
  ];

  constructor(
    private dialog: MatDialog,
    private eventService: EventService,
    private snackBar: MatSnackBar
  ) {}

  ngOnInit() {
    const savedTheme = localStorage.getItem('theme');
    if (savedTheme === 'light') {
      this.isLightTheme = true;
      document.documentElement.classList.add('light-theme');
    }
  }

  get unreadCount() {
    return this.notifications.filter(n => n.unread).length;
  }

  toggleTheme() {
    this.isLightTheme = !this.isLightTheme;
    if (this.isLightTheme) {
      document.documentElement.classList.add('light-theme');
      localStorage.setItem('theme', 'light');
    } else {
      document.documentElement.classList.remove('light-theme');
      localStorage.setItem('theme', 'dark');
    }
  }

  markAllAsRead() {
    this.notifications.forEach(n => n.unread = false);
  }

  markAllRead() {
    this.hasUnreadNotifications = false;
    this.notifications.forEach(n => n.unread = false);
  }

  toggleNotifications() {
    this.showNotifications = !this.showNotifications;
  }

  getNotificationColor(color: string) {
    const colors: { [key: string]: string } = {
      'orange': '#FF9800',
      'red': '#F44336',
      'blue': '#2196F3',
      'green': '#00E676'
    };
    return colors[color] || '#FF9800';
  }

  navMain = [
    { label: 'Dashboard', icon: 'dashboard', route: '/', exact: true },
    { label: 'Analytics', icon: 'bar_chart', route: '/analytics', exact: false },
    { label: 'Heatmap', icon: 'map', route: '/heatmap', exact: false },
  ];

  navManage = [
    { label: 'Users', icon: 'group', route: '/users', exact: false },
    { label: 'Food Trucks', icon: 'local_shipping', route: '/trucks', exact: false, badge: '3 Pending' },
    { label: 'Support Tickets', icon: 'support_agent', route: '/support', exact: false },
  ];

  navGame = [
    { label: 'Events', icon: 'event', route: '/events', exact: false },
    { label: 'Collectibles', icon: 'inventory_2', route: '/items', exact: false },
    { label: 'Rewards', icon: 'redeem', route: '/rewards', exact: false },
  ];

  openNewEventDialog() {
    const dialogRef = this.dialog.open(EventDialogComponent, {
      width: '500px'
    });

    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        this.eventService.addEvent(result);
        this.snackBar.open('Global Event created successfully', 'Close', { duration: 3000 });
      }
    });
  }

  signOut() {
    const dialogRef = this.dialog.open(ConfirmDialogComponent, {
      width: '450px',
      panelClass: 'transparent-dialog',
      data: {
        title: 'Sign Out',
        message: 'Are you sure you want to sign out of the dashboard?',
        confirmText: 'Sign Out',
        cancelText: 'Cancel'
      }
    });

    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        this.snackBar.open('Signed out successfully.', 'Close', { duration: 3000 });
      }
    });
  }
}
