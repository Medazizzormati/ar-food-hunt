import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';

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
  private initialItems: Item[] = [
    { id: '1', name: 'Golden Spatula', type: 'Ingredient', rarity: 'Legendary' },
    { id: '2', name: 'Mystery Box', type: 'Consumable', rarity: 'Rare' }
  ];

  private itemsSubject = new BehaviorSubject<Item[]>(this.initialItems);
  items$ = this.itemsSubject.asObservable();

  constructor() { }

  getItems(): Item[] {
    return this.itemsSubject.value;
  }

  addItem(item: Omit<Item, 'id'>) {
    const newItem = { ...item, id: Math.random().toString(36).substring(2, 9) };
    this.itemsSubject.next([...this.getItems(), newItem]);
  }

  updateItem(updatedItem: Item) {
    const items = this.getItems().map(i => i.id === updatedItem.id ? updatedItem : i);
    this.itemsSubject.next(items);
  }

  deleteItem(id: string) {
    const items = this.getItems().filter(i => i.id !== id);
    this.itemsSubject.next(items);
  }
}
