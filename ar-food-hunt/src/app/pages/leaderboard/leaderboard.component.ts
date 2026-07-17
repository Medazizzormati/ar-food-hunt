import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-leaderboard',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './leaderboard.component.html',
  styleUrl: './leaderboard.component.scss'
})
export class LeaderboardComponent {
  timePeriods = ['Today', 'Week', 'Month', 'All Time'];
  activePeriod = 'Week';
  categories = ['XP Ranking', 'Most Explorers', 'Rare Hunters', 'Collectors', 'Friends'];
  activeCategory = 'XP Ranking';

  allPlayers = [
    { name: 'Felix',   title: 'Burger Master',     level: 8,  trucks: 22, xp: 4850, change: 0,  isMe: false },
    { name: 'Luna',    title: 'Taco Legend',        level: 7,  trucks: 18, xp: 3280, change: 1,  isMe: false },
    { name: 'Aria',    title: 'Ice Cream Seeker',   level: 6,  trucks: 14, xp: 2100, change: -1, isMe: false },
    { name: 'Marco',   title: 'Pizza Hunter',       level: 7,  trucks: 15, xp: 1920, change: 2,  isMe: false },
    { name: 'Zara',    title: 'Coffee Collector',   level: 6,  trucks: 13, xp: 1740, change: -1, isMe: false },
    { name: 'Alex',    title: 'Novice Explorer',    level: 4,  trucks: 12, xp: 850,  change: 0,  isMe: true  },
    { name: 'Omar',    title: 'Food Wanderer',      level: 3,  trucks: 9,  xp: 720,  change: -2, isMe: false },
    { name: 'Priya',   title: 'Spice Chaser',       level: 3,  trucks: 8,  xp: 660,  change: 1,  isMe: false },
    { name: 'Ethan',   title: 'Newcomer',           level: 2,  trucks: 5,  xp: 430,  change: 3,  isMe: false },
  ];

  getRankClass(rank: number): string {
    return rank <= 3 ? `rank-${rank}` : '';
  }
}
