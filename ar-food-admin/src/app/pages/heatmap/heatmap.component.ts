import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-heatmap',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './heatmap.component.html',
  styleUrl: './heatmap.component.scss'
})
export class HeatmapComponent {
  hotspots = [
    { top: '30%', left: '40%', intensity: 'high' },
    { top: '50%', left: '60%', intensity: 'medium' },
    { top: '20%', left: '70%', intensity: 'low' },
    { top: '70%', left: '30%', intensity: 'medium' }
  ];
}
