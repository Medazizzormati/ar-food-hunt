import { Component, Inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { MatDialogRef, MAT_DIALOG_DATA, MatDialogModule } from '@angular/material/dialog';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select';
import { MatButtonModule } from '@angular/material/button';
import { Item } from '../../../services/item.service';

@Component({
  selector: 'app-item-dialog',
  standalone: true,
  imports: [
    CommonModule, 
    ReactiveFormsModule, 
    MatDialogModule, 
    MatFormFieldModule, 
    MatInputModule, 
    MatSelectModule, 
    MatButtonModule
  ],
  templateUrl: './item-dialog.component.html',
  styleUrl: './item-dialog.component.scss'
})
export class ItemDialogComponent {
  form: FormGroup;
  isEditMode: boolean;

  constructor(
    private fb: FormBuilder,
    public dialogRef: MatDialogRef<ItemDialogComponent>,
    @Inject(MAT_DIALOG_DATA) public data: Item
  ) {
    this.isEditMode = !!data;
    this.form = this.fb.group({
      name: [data?.name || '', Validators.required],
      type: [data?.type || 'Ingredient', Validators.required],
      rarity: [data?.rarity || 'Common', Validators.required]
    });
  }

  save() {
    if (this.form.valid) {
      const result = this.isEditMode ? { ...this.data, ...this.form.value } : this.form.value;
      this.dialogRef.close(result);
    }
  }
}
