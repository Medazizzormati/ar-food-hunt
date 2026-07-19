export interface Collectible {
  id?: number;
  name: string;
  model3D?: string;
  type?: string;
  xpReward?: number;
  coinReward?: number;
  latitude?: number;
  longitude?: number;
  available?: boolean;
  foodTruckId?: number;
}
