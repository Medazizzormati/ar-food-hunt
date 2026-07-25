export class AppConstants {
  static readonly APP_NAME = 'AR Food Hunt';
  static readonly APP_VERSION = '1.0.0';
  
  // API Configuration
  static readonly API_BASE_URL = 'http://localhost:8080/api';
  static readonly API_TIMEOUT = 30000;
  
  // Storage Keys
  static readonly TOKEN_KEY = 'auth_token';
  static readonly USER_KEY = 'user_data';
  static readonly THEME_KEY = 'theme_mode';
  
  // Pagination
  static readonly DEFAULT_PAGE_SIZE = 20;
  
  // Roles
  static readonly ROLES = {
    USER: 'USER',
    MODERATOR: 'MODERATOR',
    ADMIN: 'ADMIN'
  } as const;
  
  // Status Codes
  static readonly STATUS_CODES = {
    OK: 200,
    CREATED: 201,
    NO_CONTENT: 204,
    BAD_REQUEST: 400,
    UNAUTHORIZED: 401,
    FORBIDDEN: 403,
    NOT_FOUND: 404,
    CONFLICT: 409,
    INTERNAL_SERVER_ERROR: 500
  } as const;
}
