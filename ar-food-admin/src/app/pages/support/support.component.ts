import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatDialog, MatDialogModule } from '@angular/material/dialog';
import { MatSnackBar, MatSnackBarModule } from '@angular/material/snack-bar';
import { SupportService, Ticket } from '../../services/support.service';
import { SupportDialogComponent } from './support-dialog/support-dialog.component';
import { ConfirmDialogComponent } from '../../shared/confirm-dialog/confirm-dialog.component';

@Component({
  selector: 'app-support',
  standalone: true,
  imports: [CommonModule, MatDialogModule, MatSnackBarModule],
  templateUrl: './support.component.html',
  styleUrl: './support.component.scss'
})
export class SupportComponent implements OnInit {
  tickets: Ticket[] = [];

  constructor(
    private supportService: SupportService,
    private dialog: MatDialog,
    private snackBar: MatSnackBar
  ) {}

  ngOnInit() {
    this.supportService.tickets$.subscribe(data => {
      this.tickets = data;
    });
  }

  openSupportDialog(ticket?: Ticket) {
    const dialogRef = this.dialog.open(SupportDialogComponent, {
      width: '500px',
      data: ticket
    });

    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        if (ticket) {
          this.supportService.updateTicket(result);
          this.snackBar.open('Ticket updated successfully', 'Close', { duration: 3000 });
        } else {
          this.supportService.addTicket(result);
          this.snackBar.open('Ticket created successfully', 'Close', { duration: 3000 });
        }
      }
    });
  }

  deleteTicket(id: string) {
    const dialogRef = this.dialog.open(ConfirmDialogComponent, {
      width: '450px',
      panelClass: 'transparent-dialog',
      data: {
        title: 'Delete Ticket',
        message: 'Are you sure you want to delete this ticket? This action cannot be undone.',
        confirmText: 'Delete',
        cancelText: 'Cancel'
      }
    });

    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        this.supportService.deleteTicket(id);
        this.snackBar.open('Ticket deleted successfully', 'Close', { duration: 3000 });
      }
    });
  }
}
