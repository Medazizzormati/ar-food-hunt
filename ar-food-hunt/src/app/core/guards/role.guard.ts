import { Injectable } from '@angular/core';
import {
  CanActivate,
  Router,
  ActivatedRouteSnapshot,
  RouterStateSnapshot
} from '@angular/router';
import { AppConstants } from '../constants/app.constants';

@Injectable({
  providedIn: 'root'
})
export class RoleGuard implements CanActivate {
  constructor(private router: Router) {}

  canActivate(
    route: ActivatedRouteSnapshot,
    state: RouterStateSnapshot
  ): boolean {
    const token = localStorage.getItem(AppConstants.TOKEN_KEY);
    
    if (!token) {
      this.router.navigate(['/login']);
      return false;
    }

    const user = JSON.parse(localStorage.getItem(AppConstants.USER_KEY) || '{}');
    const requiredRoles = route.data['roles'] as string[];
    
    if (requiredRoles && !requiredRoles.includes(user.role)) {
      this.router.navigate(['/home']);
      return false;
    }
    
    return true;
  }
}
