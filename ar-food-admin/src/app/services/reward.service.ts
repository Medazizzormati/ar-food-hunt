import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';

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
  private initialRewards: Reward[] = [
    { id: '1', name: 'Free Burger Coupon', cost: 500, status: 'Active' },
    { id: '2', name: '10% Off Drinks', cost: 200, status: 'Active' }
  ];

  private rewardsSubject = new BehaviorSubject<Reward[]>(this.initialRewards);
  rewards$ = this.rewardsSubject.asObservable();

  constructor() { }

  getRewards(): Reward[] {
    return this.rewardsSubject.value;
  }

  addReward(reward: Omit<Reward, 'id'>) {
    const newReward = { ...reward, id: Math.random().toString(36).substring(2, 9) };
    this.rewardsSubject.next([...this.getRewards(), newReward]);
  }

  updateReward(updatedReward: Reward) {
    const rewards = this.getRewards().map(r => r.id === updatedReward.id ? updatedReward : r);
    this.rewardsSubject.next(rewards);
  }

  deleteReward(id: string) {
    const rewards = this.getRewards().filter(r => r.id !== id);
    this.rewardsSubject.next(rewards);
  }
}
