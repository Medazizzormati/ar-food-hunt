import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';

export interface Ticket {
  id: string;
  user: string;
  issue: string;
  status: string;
}

@Injectable({
  providedIn: 'root'
})
export class SupportService {
  private initialTickets: Ticket[] = [
    { id: '1', user: 'Alex Hunter', issue: 'App crashed when catching burger', status: 'Open' },
    { id: '2', user: 'Maria Garcia', issue: 'Missing points', status: 'Closed' }
  ];

  private ticketsSubject = new BehaviorSubject<Ticket[]>(this.initialTickets);
  tickets$ = this.ticketsSubject.asObservable();

  constructor() { }

  getTickets(): Ticket[] {
    return this.ticketsSubject.value;
  }

  addTicket(ticket: Omit<Ticket, 'id'>) {
    const newTicket = { ...ticket, id: Math.random().toString(36).substring(2, 9) };
    this.ticketsSubject.next([...this.getTickets(), newTicket]);
  }

  updateTicket(updatedTicket: Ticket) {
    const tickets = this.getTickets().map(t => t.id === updatedTicket.id ? updatedTicket : t);
    this.ticketsSubject.next(tickets);
  }

  deleteTicket(id: string) {
    const tickets = this.getTickets().filter(t => t.id !== id);
    this.ticketsSubject.next(tickets);
  }
}
