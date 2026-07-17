import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

interface Event {
  id: string;
  name: string;
  type: string;
  multiplier: string;
  duration: string;
  status: 'Active' | 'Upcoming' | 'Ended';
  description: string;
  emoji: string;
  joined: boolean;
}

@Component({
  selector: 'app-events',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './events.component.html',
  styleUrl: './events.component.scss'
})
export class EventsComponent {
  events: Event[] = [
    {
      id: '1',
      name: 'Summer Burger Week',
      type: 'Multiplier',
      multiplier: '2x',
      duration: '7 Days',
      status: 'Active',
      description: 'Double XP at all Burger Trucks! Collect burgers to earn bonus rewards.',
      emoji: '🍔',
      joined: false,
    },
    {
      id: '2',
      name: 'Taco Tuesday',
      type: 'Special Drop',
      multiplier: '1.5x',
      duration: '24 Hours',
      status: 'Upcoming',
      description: 'Special taco collectibles available for limited time.',
      emoji: '🌮',
      joined: false,
    },
    {
      id: '3',
      name: 'Pizza Party',
      type: 'Community Goal',
      multiplier: '3x',
      duration: '3 Days',
      status: 'Ended',
      description: 'Collect pizzas together to unlock community rewards.',
      emoji: '🍕',
      joined: false,
    },
  ];

  joinEvent(event: Event) {
    event.joined = !event.joined;
    console.log(event.joined ? 'Joined event' : 'Left event', event.name);
  }

  getStatusClass(status: string): string {
    switch (status) {
      case 'Active': return 'badge-success';
      case 'Upcoming': return 'badge-orange';
      case 'Ended': return 'badge-secondary';
      default: return 'badge-secondary';
    }
  }

  get activeEvents(): Event[] {
    return this.events.filter(e => e.status === 'Active');
  }

  get upcomingEvents(): Event[] {
    return this.events.filter(e => e.status === 'Upcoming');
  }

  get endedEvents(): Event[] {
    return this.events.filter(e => e.status === 'Ended');
  }
}
