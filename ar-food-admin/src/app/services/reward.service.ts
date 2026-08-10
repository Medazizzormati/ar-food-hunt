import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';
import { ApiService } from './api.service';

export interface Reward {
  id: string;
  name: string;
  cost: number;
  status: string;
}

@Injectable({
  providedIn: 'root'
})
export class RewardService {
  private rewardsSubject = new BehaviorSubject<Reward[]>([]);
  rewards$ = this.rewardsSubject.asObservable();

  constructor(private apiService: ApiService) {
    this.fetchRewards();
  }

  fetchRewards() {
    this.apiService.getRewards().subscribe((data: any[]) => {
      const rewards: Reward[] = data.map(r => ({
        id: r.id ? r.id.toString() : '',
        name: r.name || r.rewardName || '',
        cost: r.cost || 0,
        status: r.status || 'Active'
      }));
      this.rewardsSubject.next(rewards);
    });
  }

  getRewards(): Reward[] {
    return this.rewardsSubject.value;
  }

  addReward(reward: Omit<Reward, 'id'>) {
    this.apiService.createReward(reward).subscribe((newReward: any) => {
      const formattedReward = { ...reward, id: newReward.id ? newReward.id.toString() : Math.random().toString(36).substring(2, 9) };
      this.rewardsSubject.next([...this.getRewards(), formattedReward]);
    });
  }

  updateReward(updatedReward: Reward) {
    this.apiService.updateReward(Number(updatedReward.id), updatedReward).subscribe(() => {
      const rewards = this.getRewards().map(r => r.id === updatedReward.id ? updatedReward : r);
      this.rewardsSubject.next(rewards);
    });
  }

  deleteReward(id: string) {
    this.apiService.deleteReward(Number(id)).subscribe(() => {
      const rewards = this.getRewards().filter(r => r.id !== id);
      this.rewardsSubject.next(rewards);
    });
  }
}
