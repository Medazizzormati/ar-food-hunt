import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { MatSnackBar, MatSnackBarModule } from '@angular/material/snack-bar';

interface SettingItem {
  id: string;
  category: string;
  title: string;
  description: string;
  type: 'toggle' | 'select' | 'input' | 'button';
  value: any;
  options?: string[];
}

@Component({
  selector: 'app-settings',
  standalone: true,
  imports: [CommonModule, FormsModule, MatSnackBarModule],
  templateUrl: './settings.component.html',
  styleUrl: './settings.component.scss'
})
export class SettingsComponent implements OnInit {
  settings: SettingItem[] = [];

  constructor(private snackBar: MatSnackBar) {}

  ngOnInit() {
    this.loadSettings();
  }

  loadSettings() {
    this.settings = [
      {
        id: 'darkMode',
        category: 'Appearance',
        title: 'Dark Mode',
        description: 'Toggle dark theme for the admin panel',
        type: 'toggle',
        value: localStorage.getItem('theme') !== 'light'
      },
      {
        id: 'notifications',
        category: 'Notifications',
        title: 'Push Notifications',
        description: 'Receive browser notifications for important events',
        type: 'toggle',
        value: true
      },
      {
        id: 'emailAlerts',
        category: 'Notifications',
        title: 'Email Alerts',
        description: 'Receive email summaries of admin activities',
        type: 'toggle',
        value: false
      },
      {
        id: 'language',
        category: 'General',
        title: 'Language',
        description: 'Select your preferred language',
        type: 'select',
        value: 'English',
        options: ['English', 'French', 'Spanish', 'German', 'Arabic']
      },
      {
        id: 'timezone',
        category: 'General',
        title: 'Timezone',
        description: 'Set your timezone for reports and analytics',
        type: 'select',
        value: 'UTC',
        options: ['UTC', 'EST', 'PST', 'CET', 'GMT']
      },
      {
        id: 'itemsPerPage',
        category: 'Display',
        title: 'Items Per Page',
        description: 'Number of items to display in tables',
        type: 'select',
        value: '25',
        options: ['10', '25', '50', '100']
      },
      {
        id: 'compactMode',
        category: 'Display',
        title: 'Compact Mode',
        description: 'Use more compact layout for tables and lists',
        type: 'toggle',
        value: false
      },
      {
        id: 'autoRefresh',
        category: 'Data',
        title: 'Auto Refresh',
        description: 'Automatically refresh data every 30 seconds',
        type: 'toggle',
        value: true
      },
      {
        id: 'clearCache',
        category: 'Data',
        title: 'Clear Cache',
        description: 'Clear application cache and reload data',
        type: 'button',
        value: 'Clear Cache'
      },
      {
        id: 'exportData',
        category: 'Data',
        title: 'Export All Data',
        description: 'Export all admin data as JSON backup',
        type: 'button',
        value: 'Export Data'
      }
    ];
  }

  toggleSetting(item: SettingItem) {
    if (item.type === 'toggle') {
      item.value = !item.value;
      
      if (item.id === 'darkMode') {
        this.applyTheme(item.value);
      }
      
      this.snackBar.open(`${item.title} ${item.value ? 'enabled' : 'disabled'}`, 'Close', { duration: 2000 });
    }
  }

  selectOption(item: SettingItem, option: string) {
    item.value = option;
    this.snackBar.open(`${item.title} set to ${option}`, 'Close', { duration: 2000 });
  }

  buttonAction(item: SettingItem) {
    if (item.id === 'clearCache') {
      localStorage.clear();
      this.snackBar.open('Cache cleared successfully', 'Close', { duration: 3000 });
      setTimeout(() => location.reload(), 1000);
    } else if (item.id === 'exportData') {
      this.exportAllData();
    }
  }

  applyTheme(isDark: boolean) {
    if (isDark) {
      document.documentElement.classList.remove('light-theme');
      localStorage.setItem('theme', 'dark');
    } else {
      document.documentElement.classList.add('light-theme');
      localStorage.setItem('theme', 'light');
    }
  }

  exportAllData() {
    const data = {
      settings: this.settings,
      exportDate: new Date().toISOString(),
      version: '1.0.0'
    };
    
    const blob = new Blob([JSON.stringify(data, null, 2)], { type: 'application/json' });
    const link = document.createElement('a');
    const url = URL.createObjectURL(blob);
    
    link.setAttribute('href', url);
    link.setAttribute('download', 'admin_data_backup.json');
    link.style.visibility = 'hidden';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    
    this.snackBar.open('Data exported successfully', 'Close', { duration: 3000 });
  }

  getSettingsByCategory(category: string): SettingItem[] {
    return this.settings.filter(s => s.category === category);
  }

  get categories(): string[] {
    return [...new Set(this.settings.map(s => s.category))];
  }
}
