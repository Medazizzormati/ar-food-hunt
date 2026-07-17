import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';

export interface GameEvent {
  id: string;
  name: string;
  type: string;
  multiplier: string;
  duration: string;
  status: string;
}

@Injectable({
  providedIn: 'root'
})
export class EventService {
  private initialEvents: GameEvent[] = [
    { id: '1', name: 'Summer Burger Week', type: 'Multiplier', multiplier: '2x', duration: '7 Days', status: 'Active' },
    { id: '2', name: 'Taco Tuesday', type: 'Special Drop', multiplier: '1.5x', duration: '24 Hours', status: 'Upcoming' },
    { id: '3', name: 'Pizza Party', type: 'Community Goal', multiplier: '3x', duration: '3 Days', status: 'Ended' }
  ];

  private eventsSubject = new BehaviorSubject<GameEvent[]>(this.initialEvents);
  events$ = this.eventsSubject.asObservable();

  constructor() { }

  getEvents(): GameEvent[] {
    return this.eventsSubject.value;
  }

  addEvent(event: Omit<GameEvent, 'id'>) {
    const newEvent = { ...event, id: Math.random().toString(36).substring(2, 9) };
    this.eventsSubject.next([...this.getEvents(), newEvent]);
  }

  updateEvent(updatedEvent: GameEvent) {
    const events = this.getEvents().map(e => e.id === updatedEvent.id ? updatedEvent : e);
    this.eventsSubject.next(events);
  }

  deleteEvent(id: string) {
    const events = this.getEvents().filter(e => e.id !== id);
    this.eventsSubject.next(events);
  }
}
