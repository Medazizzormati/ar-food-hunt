import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatDialog, MatDialogModule } from '@angular/material/dialog';
import { MatSnackBar, MatSnackBarModule } from '@angular/material/snack-bar';
import { EventService, GameEvent } from '../../services/event.service';
import { EventDialogComponent } from './event-dialog/event-dialog.component';
import { ConfirmDialogComponent } from '../../shared/confirm-dialog/confirm-dialog.component';

@Component({
  selector: 'app-events',
  standalone: true,
  imports: [CommonModule, MatDialogModule, MatSnackBarModule],
  templateUrl: './events.component.html',
  styleUrl: './events.component.scss'
})
export class EventsComponent implements OnInit {
  events: GameEvent[] = [];

  constructor(
    private eventService: EventService,
    private dialog: MatDialog,
    private snackBar: MatSnackBar
  ) {}

  ngOnInit() {
    this.eventService.events$.subscribe(data => {
      this.events = data;
    });
  }

  openEventDialog(event?: GameEvent) {
    const dialogRef = this.dialog.open(EventDialogComponent, {
      width: '500px',
      data: event
    });

    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        if (event) {
          this.eventService.updateEvent(result);
          this.snackBar.open('Event updated successfully', 'Close', { duration: 3000 });
        } else {
          this.eventService.addEvent(result);
          this.snackBar.open('Event created successfully', 'Close', { duration: 3000 });
        }
      }
    });
  }

  deleteEvent(id: string) {
    const dialogRef = this.dialog.open(ConfirmDialogComponent, {
      width: '450px',
      panelClass: 'transparent-dialog',
      data: {
        title: 'Delete Event',
        message: 'Are you sure you want to delete this event? This action cannot be undone.',
        confirmText: 'Delete',
        cancelText: 'Cancel'
      }
    });

    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        this.eventService.deleteEvent(id);
        this.snackBar.open('Event deleted successfully', 'Close', { duration: 3000 });
      }
    });
  }
}
