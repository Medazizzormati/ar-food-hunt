import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-analytics',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './analytics.component.html',
  styleUrl: './analytics.component.scss'
})
export class AnalyticsComponent {
  platforms = [
    { name: 'iOS', percentage: 65, color: '#3B82F6' },
    { name: 'Android', percentage: 35, color: '#10B981' }
  ];
}
