import { Component, Inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { MatDialogRef, MAT_DIALOG_DATA, MatDialogModule } from '@angular/material/dialog';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select';
import { MatButtonModule } from '@angular/material/button';
import { Reward } from '../../../services/reward.service';

@Component({
  selector: 'app-reward-dialog',
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
  templateUrl: './reward-dialog.component.html',
  styleUrl: './reward-dialog.component.scss'
})
export class RewardDialogComponent {
  form: FormGroup;
  isEditMode: boolean;

  constructor(
    private fb: FormBuilder,
    public dialogRef: MatDialogRef<RewardDialogComponent>,
    @Inject(MAT_DIALOG_DATA) public data: Reward
  ) {
    this.isEditMode = !!data;
    this.form = this.fb.group({
      name: [data?.name || '', Validators.required],
      cost: [data?.cost || 100, [Validators.required, Validators.min(0)]],
      status: [data?.status || 'Active', Validators.required]
    });
  }

  save() {
    if (this.form.valid) {
      const result = this.isEditMode ? { ...this.data, ...this.form.value } : this.form.value;
      this.dialogRef.close(result);
    }
  }
}
