import { Component, Inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { MatDialogRef, MAT_DIALOG_DATA, MatDialogModule } from '@angular/material/dialog';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select';
import { MatButtonModule } from '@angular/material/button';
import { Ticket } from '../../../services/support.service';

@Component({
  selector: 'app-support-dialog',
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
  templateUrl: './support-dialog.component.html',
  styleUrl: './support-dialog.component.scss'
})
export class SupportDialogComponent {
  form: FormGroup;
  isEditMode: boolean;

  constructor(
    private fb: FormBuilder,
    public dialogRef: MatDialogRef<SupportDialogComponent>,
    @Inject(MAT_DIALOG_DATA) public data: Ticket
  ) {
    this.isEditMode = !!data;
    this.form = this.fb.group({
      user: [data?.user || '', Validators.required],
      issue: [data?.issue || '', Validators.required],
      status: [data?.status || 'Open', Validators.required]
    });
  }

  save() {
    if (this.form.valid) {
      const result = this.isEditMode ? { ...this.data, ...this.form.value } : this.form.value;
      this.dialogRef.close(result);
    }
  }
}
