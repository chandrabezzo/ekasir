# 🚀 Quick Start: Deploy to GitHub Pages

## Step 1: Enable GitHub Pages
1. Go to **Settings** → **Pages** in your repository
2. Set **Source** to **GitHub Actions**

## Step 2: Push the Workflow
```bash
git add .github/workflows/deploy.yml web/.nojekyll GITHUB_PAGES_SETUP.md DEPLOYMENT_QUICKSTART.md
git commit -m "Configure GitHub Actions for automated deployment"
git push origin main
```

## Step 3: Monitor Deployment
- Go to **Actions** tab in your GitHub repository
- Watch the deployment progress
- Once complete, visit: `https://YOUR_USERNAME.github.io/ekasir/`

## 📝 Important Notes

- **Base URL**: The app will be served at `/ekasir/` path
- **Auto-deploy**: Every push to `main` triggers deployment
- **Duration**: Deployment typically takes 2-5 minutes
- **First time**: Initial setup may take slightly longer

## ⚙️ Update Base Href (if repository name differs)

If your repository is **not** named "ekasir", update line 38 in `.github/workflows/deploy.yml`:

```yaml
run: flutter build web --release --base-href /YOUR_REPO_NAME/
```

Replace `YOUR_REPO_NAME` with your actual repository name.

## 🔧 Troubleshooting

**Build fails?**
- Check Flutter version compatibility
- Verify all dependencies support web platform

**404 error?**
- Ensure GitHub Pages is enabled
- Verify base-href matches repository name
- Wait a few minutes for DNS propagation

**Permission denied?**
- Go to **Settings** → **Actions** → **General**
- Enable **Read and write permissions**

## 📚 Full Documentation
See `GITHUB_PAGES_SETUP.md` for detailed instructions and advanced configuration.
