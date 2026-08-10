import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';
import { ApiService } from './api.service';

export interface Item {
  id: string;
  name: string;
  type: string;
  rarity: string;
}

@Injectable({
  providedIn: 'root'
})
export class ItemService {
  private itemsSubject = new BehaviorSubject<Item[]>([]);
  items$ = this.itemsSubject.asObservable();

  constructor(private apiService: ApiService) {
    this.fetchItems();
  }

  fetchItems() {
    this.apiService.getItems().subscribe((data: any[]) => {
      const items: Item[] = data.map(i => ({
        id: i.id ? i.id.toString() : '',
        name: i.name || i.itemName || '',
        type: i.type || '',
        rarity: i.rarity || ''
      }));
      this.itemsSubject.next(items);
    });
  }

  getItems(): Item[] {
    return this.itemsSubject.value;
  }

  addItem(item: Omit<Item, 'id'>) {
    this.apiService.createItem(item).subscribe((newItem: any) => {
      const formattedItem = { ...item, id: newItem.id ? newItem.id.toString() : Math.random().toString(36).substring(2, 9) };
      this.itemsSubject.next([...this.getItems(), formattedItem]);
    });
  }

  updateItem(updatedItem: Item) {
    this.apiService.updateItem(Number(updatedItem.id), updatedItem).subscribe(() => {
      const items = this.getItems().map(i => i.id === updatedItem.id ? updatedItem : i);
      this.itemsSubject.next(items);
    });
  }

  deleteItem(id: string) {
    this.apiService.deleteItem(Number(id)).subscribe(() => {
      const items = this.getItems().filter(i => i.id !== id);
      this.itemsSubject.next(items);
    });
  }
}
