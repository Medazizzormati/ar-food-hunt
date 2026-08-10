import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ApiService } from '../../services/api.service';

@Component({
  selector: 'app-parks',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './parks.component.html',
  styleUrls: ['./parks.component.scss']
})
export class ParksComponent implements OnInit {
  parks: any[] = [];
  loading = false;
  error: string | null = null;
  selectedPark: any = null;
  showAddDialog = false;
  showEditDialog = false;

  constructor(private apiService: ApiService) {}

  ngOnInit(): void {
    this.loadParks();
  }

  loadParks(): void {
    this.loading = true;
    this.error = null;
    
    this.apiService.getParks().subscribe({
      next: (data) => {
        this.parks = data;
        this.loading = false;
      },
      error: (err) => {
        this.error = 'Failed to load parks';
        this.loading = false;
        console.error('Error loading parks:', err);
      }
    });
  }

  openAddDialog(): void {
    this.selectedPark = {
      name: '',
      location: '',
      description: '',
      latitude: null,
      longitude: null,
      imageUrl: '',
      active: true
    };
    this.showAddDialog = true;
  }

  openEditDialog(park: any): void {
    this.selectedPark = { ...park };
    this.showEditDialog = true;
  }

  closeDialogs(): void {
    this.showAddDialog = false;
    this.showEditDialog = false;
    this.selectedPark = null;
  }

  savePark(): void {
    if (this.showAddDialog) {
      this.apiService.createPark(this.selectedPark).subscribe({
        next: () => {
          this.loadParks();
          this.closeDialogs();
        },
        error: (err) => {
          console.error('Error creating park:', err);
        }
      });
    } else if (this.showEditDialog) {
      this.apiService.updatePark(this.selectedPark.id, this.selectedPark).subscribe({
        next: () => {
          this.loadParks();
          this.closeDialogs();
        },
        error: (err) => {
          console.error('Error updating park:', err);
        }
      });
    }
  }

  deletePark(id: number): void {
    if (confirm('Are you sure you want to delete this park?')) {
      this.apiService.deletePark(id).subscribe({
        next: () => {
          this.loadParks();
        },
        error: (err) => {
          console.error('Error deleting park:', err);
        }
      });
    }
  }

  toggleParkStatus(park: any): void {
    const updatedPark = { ...park, active: !park.active };
    this.apiService.updatePark(park.id, updatedPark).subscribe({
      next: () => {
        this.loadParks();
      },
      error: (err) => {
        console.error('Error updating park status:', err);
      }
    });
  }
}
