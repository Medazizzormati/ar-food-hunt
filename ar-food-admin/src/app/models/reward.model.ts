export interface Reward {
  id?: number;
  title: string;
  type?: string;
  value?: string;
  userId?: number;
  eventId?: number;
  redeemed?: boolean;
}
