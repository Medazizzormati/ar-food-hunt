import { Routes } from '@angular/router';
import { HomeComponent } from './pages/home/home.component';
import { MapComponent } from './pages/map/map.component';
import { HuntComponent } from './pages/hunt/hunt.component';
import { InventoryComponent } from './pages/inventory/inventory.component';
import { ProfileComponent } from './pages/profile/profile.component';
import { RewardsComponent } from './pages/rewards/rewards.component';
import { LeaderboardComponent } from './pages/leaderboard/leaderboard.component';
import { CollectionsComponent } from './pages/collections/collections.component';

export const routes: Routes = [
  { path: '', redirectTo: '/home', pathMatch: 'full' },
  { path: 'home', component: HomeComponent },
  { path: 'explore', component: MapComponent },
  { path: 'hunt', component: HuntComponent },
  { path: 'inventory', component: InventoryComponent },
  { path: 'rewards', component: RewardsComponent },
  { path: 'profile', component: ProfileComponent },
  { path: 'leaderboard', component: LeaderboardComponent },
  { path: 'collections', component: CollectionsComponent },
];
