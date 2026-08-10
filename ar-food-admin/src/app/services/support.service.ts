import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';
import { ApiService } from './api.service';

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
  private ticketsSubject = new BehaviorSubject<Ticket[]>([]);
  tickets$ = this.ticketsSubject.asObservable();

  constructor(private apiService: ApiService) {
    this.fetchTickets();
  }

  fetchTickets() {
    this.apiService.getTickets().subscribe((data: any[]) => {
      const tickets: Ticket[] = data.map(t => ({
        id: t.id ? t.id.toString() : '',
        user: t.user || t.username || '',
        issue: t.issue || t.description || '',
        status: t.status || 'Open'
      }));
      this.ticketsSubject.next(tickets);
    });
  }

  getTickets(): Ticket[] {
    return this.ticketsSubject.value;
  }

  addTicket(ticket: Omit<Ticket, 'id'>) {
    this.apiService.createTicket(ticket).subscribe((newTicket: any) => {
      const formattedTicket = { ...ticket, id: newTicket.id ? newTicket.id.toString() : Math.random().toString(36).substring(2, 9) };
      this.ticketsSubject.next([...this.getTickets(), formattedTicket]);
    });
  }

  updateTicket(updatedTicket: Ticket) {
    this.apiService.updateTicket(Number(updatedTicket.id), updatedTicket).subscribe(() => {
      const tickets = this.getTickets().map(t => t.id === updatedTicket.id ? updatedTicket : t);
      this.ticketsSubject.next(tickets);
    });
  }

  deleteTicket(id: string) {
    this.apiService.deleteTicket(Number(id)).subscribe(() => {
      const tickets = this.getTickets().filter(t => t.id !== id);
      this.ticketsSubject.next(tickets);
    });
  }
}
