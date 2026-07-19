export interface User {
  id?: number;
  username: string;
  email: string;
  password?: string;
  level?: number;
  xp?: number;
  coins?: number;
  avatar?: string;
}
