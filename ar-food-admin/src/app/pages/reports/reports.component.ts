import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatSnackBar, MatSnackBarModule } from '@angular/material/snack-bar';

interface ReportData {
  id: string;
  date: string;
  type: string;
  title: string;
  value: number;
  change: string;
  status: string;
}

@Component({
  selector: 'app-reports',
  standalone: true,
  imports: [CommonModule, MatSnackBarModule],
  templateUrl: './reports.component.html',
  styleUrl: './reports.component.scss'
})
export class ReportsComponent implements OnInit {
  selectedDateFilter = 'Last 7 Days';
  showDateDropdown = false;
  
  dateFilters = ['Last 7 Days', 'Last 30 Days', 'Last 90 Days', 'This Year', 'Custom Range'];

  reportData: ReportData[] = [
    { id: '1', date: '2024-07-16', type: 'Coupons', title: 'Coupons Redeemed', value: 1247, change: '+5.2%', status: 'Active' },
    { id: '2', date: '2024-07-15', type: 'Users', title: 'New Users', value: 89, change: '+12.3%', status: 'Active' },
    { id: '3', date: '2024-07-14', type: 'Trucks', title: 'Truck Registrations', value: 12, change: '+8.1%', status: 'Pending' },
    { id: '4', date: '2024-07-13', type: 'Events', title: 'Event Participation', value: 456, change: '+28.4%', status: 'Active' },
    { id: '5', date: '2024-07-12', type: 'Collectibles', title: 'Items Collected', value: 2341, change: '+15.7%', status: 'Active' },
    { id: '6', date: '2024-07-11', type: 'Rewards', title: 'Rewards Claimed', value: 78, change: '+3.2%', status: 'Active' },
    { id: '7', date: '2024-07-10', type: 'Coupons', title: 'Coupons Redeemed', value: 1185, change: '+4.8%', status: 'Active' },
  ];

  constructor(private snackBar: MatSnackBar) {}

  ngOnInit() {}

  toggleDateDropdown() {
    this.showDateDropdown = !this.showDateDropdown;
  }

  selectDateFilter(filter: string) {
    this.selectedDateFilter = filter;
    this.showDateDropdown = false;
    this.snackBar.open(`Date filter changed to: ${filter}`, 'Close', { duration: 2000 });
  }

  exportReport() {
    const headers = ['Date', 'Type', 'Title', 'Value', 'Change', 'Status'];
    const csvContent = [
      headers.join(','),
      ...this.reportData.map(item => 
        [item.date, item.type, item.title, item.value, item.change, item.status].join(',')
      )
    ].join('\n');

    const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
    const link = document.createElement('a');
    const url = URL.createObjectURL(blob);
    
    link.setAttribute('href', url);
    link.setAttribute('download', `report_${this.selectedDateFilter.replace(/\s+/g, '_')}.csv`);
    link.style.visibility = 'hidden';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    
    this.snackBar.open('Report exported successfully', 'Close', { duration: 3000 });
  }

  getChangeColor(change: string): string {
    return change.startsWith('+') ? '#00E676' : '#FF5252';
  }
}
