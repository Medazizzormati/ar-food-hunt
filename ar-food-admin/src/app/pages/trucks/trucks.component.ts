import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatDialog, MatDialogModule } from '@angular/material/dialog';
import { MatSnackBar, MatSnackBarModule } from '@angular/material/snack-bar';
import { TruckService, Truck } from '../../services/truck.service';
import { TruckDialogComponent } from './truck-dialog/truck-dialog.component';
import { ConfirmDialogComponent } from '../../shared/confirm-dialog/confirm-dialog.component';

@Component({
  selector: 'app-trucks',
  standalone: true,
  imports: [CommonModule, MatDialogModule, MatSnackBarModule],
  templateUrl: './trucks.component.html',
  styleUrl: './trucks.component.scss'
})
export class TrucksComponent implements OnInit {
  trucks: Truck[] = [];

  constructor(
    private truckService: TruckService,
    private dialog: MatDialog,
    private snackBar: MatSnackBar
  ) {}

  ngOnInit() {
    this.truckService.trucks$.subscribe(data => {
      this.trucks = data;
    });
  }

  openTruckDialog(truck?: Truck) {
    const dialogRef = this.dialog.open(TruckDialogComponent, {
      width: '500px',
      data: truck
    });

    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        if (truck) {
          this.truckService.updateTruck(result);
          this.snackBar.open('Truck updated successfully', 'Close', { duration: 3000 });
        } else {
          this.truckService.addTruck(result);
          this.snackBar.open('Truck registered successfully', 'Close', { duration: 3000 });
        }
      }
    });
  }

  approveTruck(truck: Truck) {
    const updated = { ...truck, status: 'Active' };
    this.truckService.updateTruck(updated);
    this.snackBar.open('Truck Approved!', 'Close', { duration: 3000 });
  }

  exportToCSV() {
    const headers = ['Truck Name', 'Owner', 'Category', 'Location', 'Status'];
    const csvContent = [
      headers.join(','),
      ...this.trucks.map(truck => 
        [truck.name, truck.owner, truck.category, truck.location, truck.status].join(',')
      )
    ].join('\n');

    const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
    const link = document.createElement('a');
    const url = URL.createObjectURL(blob);
    
    link.setAttribute('href', url);
    link.setAttribute('download', 'food_trucks.csv');
    link.style.visibility = 'hidden';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    
    this.snackBar.open('CSV exported successfully', 'Close', { duration: 3000 });
  }
}
