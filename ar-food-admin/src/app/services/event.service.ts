import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';
import { ApiService } from './api.service';

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
  private eventsSubject = new BehaviorSubject<GameEvent[]>([]);
  events$ = this.eventsSubject.asObservable();

  constructor(private apiService: ApiService) {
    this.fetchEvents();
  }

  fetchEvents() {
    this.apiService.getEvents().subscribe((data: any[]) => {
      const events: GameEvent[] = data.map(e => ({
        id: e.id ? e.id.toString() : '',
        name: e.name || e.eventName || '',
        type: e.type || '',
        multiplier: e.multiplier || '1x',
        duration: e.duration || '',
        status: e.status || 'Active'
      }));
      this.eventsSubject.next(events);
    });
  }

  getEvents(): GameEvent[] {
    return this.eventsSubject.value;
  }

  addEvent(event: Omit<GameEvent, 'id'>) {
    this.apiService.createEvent(event).subscribe((newEvent: any) => {
      const formattedEvent = { ...event, id: newEvent.id ? newEvent.id.toString() : Math.random().toString(36).substring(2, 9) };
      this.eventsSubject.next([...this.getEvents(), formattedEvent]);
    });
  }

  updateEvent(updatedEvent: GameEvent) {
    this.apiService.updateEvent(Number(updatedEvent.id), updatedEvent).subscribe(() => {
      const events = this.getEvents().map(e => e.id === updatedEvent.id ? updatedEvent : e);
      this.eventsSubject.next(events);
    });
  }

  deleteEvent(id: string) {
    this.apiService.deleteEvent(Number(id)).subscribe(() => {
      const events = this.getEvents().filter(e => e.id !== id);
      this.eventsSubject.next(events);
    });
  }
}
