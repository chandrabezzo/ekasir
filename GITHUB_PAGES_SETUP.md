# GitHub Pages Deployment Setup

This guide will help you configure automatic deployment of your Flutter web app to GitHub Pages.

## Prerequisites

- GitHub repository initialized and pushed to remote
- Admin access to the repository

## Setup Steps

### 1. Enable GitHub Pages

1. Go to your GitHub repository: `https://github.com/YOUR_USERNAME/ekasir`
2. Click on **Settings** tab
3. In the left sidebar, click **Pages**
4. Under **Build and deployment**:
   - **Source**: Select **GitHub Actions**
5. Save the changes

### 2. Configure Repository Permissions

The workflow is already configured with the necessary permissions in `.github/workflows/deploy.yml`:

```yaml
permissions:
  contents: read
  pages: write
  id-token: write
```

These permissions allow the workflow to:
- Read repository contents
- Write to GitHub Pages
- Use OIDC for secure deployment

### 3. Push the Workflow

The GitHub Actions workflow has been created at `.github/workflows/deploy.yml`. 

To activate it:

```bash
# Add the workflow file
git add .github/workflows/deploy.yml

# Commit the changes
git commit -m "Add GitHub Actions workflow for Flutter web deployment"

# Push to main branch
git push origin main
```

### 4. Monitor Deployment

1. Go to your repository on GitHub
2. Click on the **Actions** tab
3. You should see the "Deploy Flutter Web to GitHub Pages" workflow running
4. Click on the workflow run to see detailed logs
5. Once completed (usually 2-5 minutes), your app will be live at:
   ```
   https://YOUR_USERNAME.github.io/ekasir/
   ```

## Workflow Details

The workflow does the following:

### Build Job
1. **Checkout repository** - Gets your code
2. **Setup Flutter** - Installs Flutter 3.24.5 (stable)
3. **Get dependencies** - Runs `flutter pub get`
4. **Build web** - Builds the Flutter web app with `--base-href /ekasir/`
5. **Upload artifact** - Prepares the build for deployment

### Deploy Job
1. **Deploy to GitHub Pages** - Publishes the built app to GitHub Pages

## Important Notes

### Base Href Configuration

The workflow uses `--base-href /ekasir/` because GitHub Pages serves your app at:
```
https://YOUR_USERNAME.github.io/ekasir/
```

If your repository has a different name, update line 38 in `.github/workflows/deploy.yml`:
```yaml
run: flutter build web --release --base-href /YOUR_REPO_NAME/
```

### Custom Domain (Optional)

If you want to use a custom domain:

1. In your repository **Settings** → **Pages**
2. Under **Custom domain**, enter your domain
3. Add a `CNAME` file to the `web/` directory:
   ```bash
   echo "your-domain.com" > web/CNAME
   ```
4. Update the workflow to use `--base-href /`:
   ```yaml
   run: flutter build web --release --base-href /
   ```

### Manual Deployment

You can also trigger deployment manually:

1. Go to **Actions** tab
2. Select "Deploy Flutter Web to GitHub Pages"
3. Click **Run workflow**
4. Choose the `main` branch
5. Click **Run workflow**

## Troubleshooting

### Build Fails

**Issue**: Flutter version mismatch

**Solution**: Update Flutter version in `.github/workflows/deploy.yml` (line 29):
```yaml
flutter-version: '3.24.5'  # Change to your Flutter version
```

**Issue**: Missing dependencies

**Solution**: Ensure all dependencies in `pubspec.yaml` are compatible with web platform

### Deployment Fails

**Issue**: Permission denied

**Solution**: 
1. Check repository **Settings** → **Actions** → **General**
2. Under **Workflow permissions**, select **Read and write permissions**
3. Check **Allow GitHub Actions to create and approve pull requests**

**Issue**: Page not found (404)

**Solution**: 
1. Verify GitHub Pages is enabled
2. Check the base-href matches your repository name
3. Wait a few minutes for DNS propagation

### Assets Not Loading

**Issue**: Images or fonts not displaying

**Solution**: Ensure all assets are listed in `pubspec.yaml` and the paths are correct:
```yaml
flutter:
  assets:
    - assets/image/
    - assets/icon/
```

## Updating the App

Every push to the `main` branch will automatically trigger a new deployment:

```bash
# Make your changes
git add .
git commit -m "Your update message"
git push origin main
```

The app will be automatically rebuilt and redeployed within a few minutes.

## Local Testing

Before pushing, test the web build locally:

```bash
# Build for web
flutter build web --release --base-href /ekasir/

# Serve locally (install dhttpd if needed: dart pub global activate dhttpd)
dart pub global activate dhttpd
dhttpd --path build/web

# Or use Python
cd build/web
python3 -m http.server 8000
```

Then open `http://localhost:8000` in your browser.

## Additional Resources

- [Flutter Web Deployment](https://docs.flutter.dev/deployment/web)
- [GitHub Pages Documentation](https://docs.github.com/en/pages)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
