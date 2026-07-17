import { Component, Inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { MatDialogRef, MAT_DIALOG_DATA, MatDialogModule } from '@angular/material/dialog';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select';
import { MatButtonModule } from '@angular/material/button';
import { User } from '../../../services/user.service';

@Component({
  selector: 'app-user-dialog',
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
  templateUrl: './user-dialog.component.html',
  styleUrl: './user-dialog.component.scss'
})
export class UserDialogComponent {
  form: FormGroup;
  isEditMode: boolean;

  constructor(
    private fb: FormBuilder,
    public dialogRef: MatDialogRef<UserDialogComponent>,
    @Inject(MAT_DIALOG_DATA) public data: User
  ) {
    this.isEditMode = !!data;
    this.form = this.fb.group({
      name: [data?.name || '', Validators.required],
      level: [data?.level || 1, [Validators.required, Validators.min(1)]],
      role: [data?.role || 'Player', Validators.required],
      status: [data?.status || 'Active', Validators.required],
      joined: [data?.joined || new Date().toLocaleDateString('en-US', { month: 'short', day: '2-digit', year: 'numeric' })]
    });
  }

  save() {
    if (this.form.valid) {
      const result = this.isEditMode ? { ...this.data, ...this.form.value } : this.form.value;
      this.dialogRef.close(result);
    }
  }
}
