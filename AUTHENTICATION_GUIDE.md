# Authentication Flow Guide

## Overview
The eKasir app now has a streamlined authentication flow with public access to the Order Page and protected access to the Dashboard and related features.

## Architecture

### Entry Point: Order Page (Public Access)
- **Default Route**: `/order` (OrderPage)
- **Features**:
  - Public access without authentication
  - Product browsing and ordering
  - Dynamic Login/Dashboard button based on auth status
  - Modern, clean UI with gradient design

### Login Page
- **Route**: `/login` (LoginPage)
- **Access**: Public, can be accessed directly
- **Features**:
  - Form validation
  - Password visibility toggle
  - Loading states
  - Demo credentials display
  - Haptic feedback

### Protected Routes (Require Authentication)
All these routes use **AuthMiddleware** for protection:
- `/dashboard` - Dashboard Page
- `/order/:id` - Order Detail Page
- `/qr/generate` - QR Generator Page

## Authentication Flow

```
App Launch
    ↓
Order Page (Public)
    ├─→ [Click "Login" button] → Login Page → Enter Credentials → Dashboard
    └─→ [Click "Dashboard" button (if logged in)] → Dashboard

Direct Dashboard Access Attempt (Without Auth)
    ↓
AuthMiddleware Intercepts
    ↓
Redirect to Login Page
    ↓
[After successful login] → Dashboard
```

## Key Components

### 1. AuthMiddleware
- **Location**: `lib/app/middlewares/auth_middleware.dart`
- **Purpose**: Protects routes from unauthorized access
- **Behavior**:
  - Checks authentication status via `AuthController.isLoggedIn`
  - Redirects to Login page if not authenticated
  - Allows access if authenticated

### 2. Order Page Header (Dynamic Button)
- **Shows "Login" button** when user is NOT logged in
  - Blue theme
  - Navigates to Login page
- **Shows "Dashboard" button** when user IS logged in
  - Purple theme
  - Navigates to Dashboard
- **Reactive**: Updates automatically when auth status changes (using Obx)

### 3. Route Configuration
**Public Routes** (No authentication required):
- `/order` - Order Page (default entry)
- `/login` - Login Page

**Protected Routes** (Authentication required via middleware):
- `/dashboard` - Dashboard Page
- `/order/:id` - Order Detail Page
- `/qr/generate` - QR Generator Page

## User Experience Flows

### Flow 1: Guest User (No Login)
1. App opens → Order Page
2. Browse products
3. Add to cart and checkout (public features)

### Flow 2: User Wants to Login
1. On Order Page → Click "Login" button
2. Enter credentials on Login Page
3. Successful login → Redirect to Dashboard
4. Button changes to "Dashboard" on Order Page

### Flow 3: Logged-in User Navigation
1. On Order Page → Click "Dashboard" button
2. Directly navigate to Dashboard (no login needed)

### Flow 4: Direct Dashboard Access (Unauthorized)
1. User tries to access `/dashboard` directly
2. AuthMiddleware checks authentication
3. User is NOT logged in → Redirect to Login Page
4. After login → Access Dashboard

### Flow 5: Dashboard to Order Page
1. User on Dashboard
2. Navigate back to Order Page (via back button or direct navigation)
3. "Dashboard" button visible (since user is logged in)

## Security Implementation

1. **Route Protection**: AuthMiddleware prevents unauthorized access
2. **Session Persistence**: SharedPreferences stores user session
3. **Password Hashing**: SHA256 for password security
4. **Automatic Logout**: Clears session and redirects to Order Page
5. **Global Auth State**: AuthController initialized in AppBinding

## Demo Credentials

- **Admin**: `admin` / `admin123`
- **Kasir 1**: `kasir1` / `kasir123`
- **Kasir 2**: `kasir2` / `kasir456`

## Testing Scenarios

### Test 1: First-time User
- Open app → See Order Page
- No login required to browse
- Click "Login" → Navigate to Login Page

### Test 2: Login Flow
- Click "Login" on Order Page
- Enter valid credentials
- Redirected to Dashboard
- Navigate back to Order Page → See "Dashboard" button

### Test 3: Protected Route Access
- Without login, navigate to `/dashboard`
- Middleware intercepts → Redirect to Login
- Login → Access Dashboard

### Test 4: Logged-in User
- Already logged in (session persisted)
- Open app → See Order Page with "Dashboard" button
- Click "Dashboard" → Direct access (no login prompt)

### Test 5: Logout Flow
- On Dashboard → Click Logout
- Confirmation dialog → Confirm
- Redirected to Order Page
- "Login" button now visible

## Files Modified/Created

### Created:
- `lib/app/middlewares/auth_middleware.dart` - Route protection

### Modified:
- `lib/app/app_routes.dart` - OrderPage as initial route, AuthMiddleware applied
- `lib/app/app_controller.dart` - Returns OrderPage as initial route
- `lib/features/order/order_page.dart` - Added dynamic Login/Dashboard button
- `lib/app/app_binding.dart` - AuthController initialized globally
- `lib/features/dashboard/dashboard_binding.dart` - Removed redundant auth check

### Deleted:
- `lib/features/splash/splash_page.dart` - Removed splash screen
- `AUTH_FLOW_GUIDE.md` - Replaced with this guide

## Benefits of This Approach

1. **Better UX**: Users can immediately access products without forced login
2. **Clear Entry Points**: Obvious "Login" button when needed
3. **Secure**: Protected routes still require authentication
4. **Flexible**: Users can login anytime they want
5. **Contextual**: Button changes based on auth status
6. **Performance**: No splash screen delay

## Future Enhancements

- Add "Guest Checkout" vs "Member Checkout" differentiation
- Implement "Remember Me" functionality
- Add biometric authentication
- Role-based dashboard features
- Session timeout with auto-logout
- Multi-factor authentication for admin
