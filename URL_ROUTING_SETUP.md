# URL Routing Configuration (Path-based, No Hash)

## Overview
Your Flutter web app has been configured to use **path-based routing** instead of hash-based routing. This means URLs will look like:

✅ **Before:** `https://chandrabezzo.github.io/ekasir/#/order`  
✅ **After:** `https://chandrabezzo.github.io/ekasir/order`

---

## Changes Made

### 1. **main.dart** - URL Strategy Configuration
**File:** `lib/main.dart`

Added `usePathUrlStrategy()` to configure Flutter web to use path-based URLs:

```dart
import 'package:flutter_web_plugins/url_strategy.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Use path-based URL strategy for web (removes # from URLs)
    if (kIsWeb) {
      usePathUrlStrategy();
    }
    
    // ... rest of initialization
  }, (error, stack) => debugPrint(error.toString()));
}
```

### 2. **index.html** - Redirect Handling
**File:** `web/index.html`

Added script to handle redirects from 404 page:

```html
<!-- GitHub Pages redirect handling for client-side routing -->
<script>
  (function(){
    var redirect = sessionStorage.redirect;
    delete sessionStorage.redirect;
    if (redirect && redirect != location.href) {
      history.replaceState(null, null, redirect);
    }
  })();
</script>
```

### 3. **404.html** - Client-Side Routing Support
**File:** `web/404.html` (NEW)

Created a 404 page that redirects to index.html while preserving the path:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Redirecting...</title>
  <script>
    // Stores the current path and redirects to index.html
    sessionStorage.redirect = location.href;
  </script>
  <meta http-equiv="refresh" content="0;URL='/'">
</head>
</html>
```

---

## How It Works

1. **User visits:** `https://chandrabezzo.github.io/ekasir/order`
2. **GitHub Pages** serves 404.html (because `/order` doesn't exist as a file)
3. **404.html** stores the URL in sessionStorage and redirects to `/`
4. **index.html** reads the stored URL and updates the browser history
5. **Flutter app** loads and renders the correct route (`/order`)

---

## Testing Locally

To test the path-based routing locally:

```bash
# Build for web
flutter build web --release

# Serve the built files (install http-server if needed)
npx http-server build/web -p 8000 -o

# Or use Python
cd build/web
python3 -m http.server 8000
```

Then navigate to:
- `http://localhost:8000/` ✅
- `http://localhost:8000/order` ✅
- `http://localhost:8000/login` ✅

All routes should work without `#`.

---

## Deployment

The GitHub Actions workflow is already configured correctly:

```yaml
- name: Build web
  run: flutter build web --release --base-href /ekasir/
```

### To Deploy:

1. Commit and push your changes:
```bash
git add .
git commit -m "Configure path-based URL routing"
git push origin main
```

2. GitHub Actions will automatically build and deploy

3. After deployment, your URLs will be:
   - ✅ `https://chandrabezzo.github.io/ekasir/`
   - ✅ `https://chandrabezzo.github.io/ekasir/order`
   - ✅ `https://chandrabezzo.github.io/ekasir/login`
   - ✅ `https://chandrabezzo.github.io/ekasir/dashboard`

---

## Important Notes

### ✅ Advantages of Path-based URLs:
- **Better SEO**: Search engines prefer clean URLs
- **Professional**: Looks more polished
- **Shareable**: Easier to share links
- **Bookmarkable**: Works better with browser bookmarks

### ⚠️ Considerations:
- **Server Configuration**: Requires 404 handling (already configured for GitHub Pages)
- **Base HREF**: Must use `--base-href /ekasir/` when building
- **Deep Linking**: All routes must be properly configured in your app

---

## Troubleshooting

### If routes don't work after deployment:

1. **Check GitHub Pages settings:**
   - Go to repository Settings → Pages
   - Ensure source is set to "GitHub Actions"
   - Wait for deployment to complete

2. **Verify 404.html is deployed:**
   - Visit `https://chandrabezzo.github.io/ekasir/nonexistent`
   - Should redirect to home page

3. **Check browser console:**
   - Open DevTools → Console
   - Look for any errors related to routing

4. **Clear browser cache:**
   ```bash
   # Hard refresh
   Ctrl+Shift+R (Windows/Linux)
   Cmd+Shift+R (Mac)
   ```

---

## Routes in Your App

Based on your app structure, these routes will work:

| Route | URL | Description |
|-------|-----|-------------|
| Order | `/order` | Order/menu page |
| Login | `/login` | Login page |
| Dashboard | `/dashboard` | Admin dashboard |
| QR Generator | `/qr/generate` | QR code generator |
| Order Detail | `/order/detail/:id` | Order details |

All without the `#` symbol!

---

## Rollback (If Needed)

If you need to revert to hash-based routing:

1. Remove `usePathUrlStrategy()` from `main.dart`
2. Delete `web/404.html`
3. Remove redirect script from `web/index.html`
4. Flutter will default back to hash-based routing

---

## Additional Resources

- [Flutter Web URL Strategies](https://docs.flutter.dev/development/ui/navigation/url-strategies)
- [GitHub Pages Client-Side Routing](https://github.com/rafgraph/spa-github-pages)
- [Flutter Web Deployment](https://docs.flutter.dev/deployment/web)

---

Your app is now configured for **clean, professional URLs** without the hash symbol! 🎉
