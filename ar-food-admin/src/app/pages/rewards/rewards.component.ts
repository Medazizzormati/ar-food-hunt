import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatDialog, MatDialogModule } from '@angular/material/dialog';
import { MatSnackBar, MatSnackBarModule } from '@angular/material/snack-bar';
import { RewardService, Reward } from '../../services/reward.service';
import { RewardDialogComponent } from './reward-dialog/reward-dialog.component';
import { ConfirmDialogComponent } from '../../shared/confirm-dialog/confirm-dialog.component';

@Component({
  selector: 'app-rewards',
  standalone: true,
  imports: [CommonModule, MatDialogModule, MatSnackBarModule],
  templateUrl: './rewards.component.html',
  styleUrl: './rewards.component.scss'
})
export class RewardsComponent implements OnInit {
  rewards: Reward[] = [];

  constructor(
    private rewardService: RewardService,
    private dialog: MatDialog,
    private snackBar: MatSnackBar
  ) {}

  ngOnInit() {
    this.rewardService.rewards$.subscribe(data => {
      this.rewards = data;
    });
  }

  openRewardDialog(reward?: Reward) {
    const dialogRef = this.dialog.open(RewardDialogComponent, {
      width: '500px',
      data: reward
    });

    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        if (reward) {
          this.rewardService.updateReward(result);
          this.snackBar.open('Reward updated successfully', 'Close', { duration: 3000 });
        } else {
          this.rewardService.addReward(result);
          this.snackBar.open('Reward created successfully', 'Close', { duration: 3000 });
        }
      }
    });
  }

  deleteReward(id: string) {
    const dialogRef = this.dialog.open(ConfirmDialogComponent, {
      width: '450px',
      panelClass: 'transparent-dialog',
      data: {
        title: 'Delete Reward',
        message: 'Are you sure you want to delete this reward? This action cannot be undone.',
        confirmText: 'Delete',
        cancelText: 'Cancel'
      }
    });

    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        this.rewardService.deleteReward(id);
        this.snackBar.open('Reward deleted successfully', 'Close', { duration: 3000 });
      }
    });
  }
}
