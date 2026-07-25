import { Injectable } from '@angular/core';
import {
  HttpRequest,
  HttpHandler,
  HttpEvent,
  HttpInterceptor,
  HttpErrorResponse
} from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { catchError } from 'rxjs/operators';

@Injectable()
export class ErrorInterceptor implements HttpInterceptor {
  intercept(
    request: HttpRequest<any>,
    next: HttpHandler
  ): Observable<HttpEvent<any>> {
    return next.handle(request).pipe(
      catchError((error: HttpErrorResponse) => {
        let errorMessage = 'An error occurred';
        
        if (error.error instanceof ErrorEvent) {
          // Client-side error
          errorMessage = error.error.message;
        } else {
          // Server-side error
          switch (error.status) {
            case 400:
              errorMessage = 'Bad Request: Invalid data provided';
              break;
            case 401:
              errorMessage = 'Unauthorized: Please login again';
              break;
            case 403:
              errorMessage = 'Forbidden: You don\'t have permission';
              break;
            case 404:
              errorMessage = 'Not Found: Resource not found';
              break;
            case 409:
              errorMessage = 'Conflict: Resource already exists';
              break;
            case 500:
              errorMessage = 'Internal Server Error: Please try again later';
              break;
            default:
              errorMessage = `Error ${error.status}: ${error.message}`;
          }
        }
        
        console.error('API Error:', errorMessage, error);
        return throwError(() => errorMessage);
      })
    );
  }
}
