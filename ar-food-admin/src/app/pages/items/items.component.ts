import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatDialog, MatDialogModule } from '@angular/material/dialog';
import { MatSnackBar, MatSnackBarModule } from '@angular/material/snack-bar';
import { ItemService, Item } from '../../services/item.service';
import { ItemDialogComponent } from './item-dialog/item-dialog.component';
import { ConfirmDialogComponent } from '../../shared/confirm-dialog/confirm-dialog.component';

@Component({
  selector: 'app-items',
  standalone: true,
  imports: [CommonModule, MatDialogModule, MatSnackBarModule],
  templateUrl: './items.component.html',
  styleUrl: './items.component.scss'
})
export class ItemsComponent implements OnInit {
  items: Item[] = [];

  constructor(
    private itemService: ItemService,
    private dialog: MatDialog,
    private snackBar: MatSnackBar
  ) {}

  ngOnInit() {
    this.itemService.items$.subscribe(data => {
      this.items = data;
    });
  }

  openItemDialog(item?: Item) {
    const dialogRef = this.dialog.open(ItemDialogComponent, {
      width: '500px',
      data: item
    });

    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        if (item) {
          this.itemService.updateItem(result);
          this.snackBar.open('Item updated successfully', 'Close', { duration: 3000 });
        } else {
          this.itemService.addItem(result);
          this.snackBar.open('Item created successfully', 'Close', { duration: 3000 });
        }
      }
    });
  }

  deleteItem(id: string) {
    const dialogRef = this.dialog.open(ConfirmDialogComponent, {
      width: '450px',
      panelClass: 'transparent-dialog',
      data: {
        title: 'Delete Item',
        message: 'Are you sure you want to delete this item? This action cannot be undone.',
        confirmText: 'Delete',
        cancelText: 'Cancel'
      }
    });

    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        this.itemService.deleteItem(id);
        this.snackBar.open('Item deleted successfully', 'Close', { duration: 3000 });
      }
    });
  }
}
