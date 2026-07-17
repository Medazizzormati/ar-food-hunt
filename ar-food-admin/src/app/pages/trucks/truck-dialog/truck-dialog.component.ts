import { Component, Inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { MatDialogRef, MAT_DIALOG_DATA, MatDialogModule } from '@angular/material/dialog';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select';
import { MatButtonModule } from '@angular/material/button';
import { Truck } from '../../../services/truck.service';

@Component({
  selector: 'app-truck-dialog',
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
  templateUrl: './truck-dialog.component.html',
  styleUrl: './truck-dialog.component.scss'
})
export class TruckDialogComponent {
  form: FormGroup;
  isEditMode: boolean;

  constructor(
    private fb: FormBuilder,
    public dialogRef: MatDialogRef<TruckDialogComponent>,
    @Inject(MAT_DIALOG_DATA) public data: Truck
  ) {
    this.isEditMode = !!data;
    this.form = this.fb.group({
      name: [data?.name || '', Validators.required],
      owner: [data?.owner || '', Validators.required],
      category: [data?.category || 'American', Validators.required],
      location: [data?.location || 'Central Park', Validators.required],
      status: [data?.status || 'Pending Approval', Validators.required]
    });
  }

  save() {
    if (this.form.valid) {
      const result = this.isEditMode ? { ...this.data, ...this.form.value } : this.form.value;
      this.dialogRef.close(result);
    }
  }
}
