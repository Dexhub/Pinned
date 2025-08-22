# Pinned Website - GitHub Pages Deployment

This is the official website for the Pinned travel tracking app, designed to be deployed on GitHub Pages.

## 🚀 Quick Start

### 1. Enable GitHub Pages

1. Go to your repository settings on GitHub
2. Scroll to "Pages" section
3. Under "Source", select "Deploy from a branch"
4. Choose "main" branch and "/docs" folder
5. Click "Save"

Your site will be available at: `https://[username].github.io/[repository-name]`

### 2. Custom Domain (Optional)

If you own `pinned.app` domain:

1. Add a `CNAME` file in the `/docs` folder with your domain
2. Configure DNS records with your domain provider:
   ```
   Type: CNAME
   Name: www
   Value: [username].github.io
   
   Type: A
   Name: @
   Values: 
   185.199.108.153
   185.199.109.153
   185.199.110.153
   185.199.111.153
   ```
3. Wait for DNS propagation (up to 24 hours)

## 📁 File Structure

```
docs/
├── index.html          # Main landing page
├── privacy.html        # Privacy policy page
├── styles.css          # All CSS styles
├── script.js           # Interactive JavaScript
├── sitemap.xml         # SEO sitemap
├── robots.txt          # Search engine instructions
├── _config.yml         # GitHub Pages configuration
├── CNAME               # Custom domain configuration
├── _redirects          # URL redirects
└── assets/
    ├── logo.svg        # Pinned logo
    ├── app-store-badge.svg
    ├── google-play-badge.svg
    ├── placeholder-generator.html
    └── README.md       # Asset guidelines
```

## 🎨 Customization

### Colors
Update CSS variables in `styles.css`:
```css
:root {
    --primary-color: #FF0080;
    --secondary-color: #0080FF;
    --accent-color: #FFD93D;
}
```

### Content
- Edit `index.html` for main content
- Update `_config.yml` for site metadata
- Modify `privacy.html` for legal content

### Assets
- Replace placeholder images in `/assets`
- Use the `placeholder-generator.html` to create temporary images
- Follow guidelines in `assets/README.md`

## 📱 Features

### ✅ Implemented
- **Responsive Design**: Works on all devices
- **Interactive Carousel**: App screenshots with touch/keyboard support
- **Smooth Animations**: CSS animations with reduced motion support
- **Accessibility**: WCAG 2.1 AA compliant
- **SEO Optimized**: Meta tags, sitemap, structured data
- **Performance**: Optimized images, lazy loading, CDN ready
- **Dark Mode**: Automatic system preference detection
- **PWA Ready**: Service worker and manifest (optional)

### 🎯 Key Sections
1. **Hero**: Eye-catching intro with app preview
2. **Features**: Six key app features with icons
3. **Personality**: Travel archetype quiz promotion
4. **Screenshots**: Interactive app preview carousel
5. **Download**: App Store buttons and info
6. **Footer**: Links, contact, and legal

## 🔧 Development

### Local Development
```bash
# Simple HTTP server
python -m http.server 8000
# Or
npx serve docs

# Visit http://localhost:8000
```

### Testing
- Test on multiple devices and browsers
- Validate HTML at https://validator.w3.org/
- Check accessibility with browser dev tools
- Test loading speed with PageSpeed Insights

## 📊 Analytics

### Google Analytics (Optional)
Add to `<head>` in `index.html`:
```html
<!-- Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=GA_MEASUREMENT_ID"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'GA_MEASUREMENT_ID');
</script>
```

### Plausible Analytics (Privacy-friendly alternative)
Already configured in `index.html`. Just update domain:
```html
<script defer data-domain="pinned.app" src="https://plausible.io/js/script.js"></script>
```

## 🚀 Deployment Checklist

### Before Going Live:
- [ ] Replace all placeholder images with actual screenshots
- [ ] Update App Store URL when app is approved
- [ ] Test all links and forms
- [ ] Validate HTML/CSS
- [ ] Test accessibility
- [ ] Check mobile responsiveness
- [ ] Optimize images (WebP format recommended)
- [ ] Set up analytics
- [ ] Configure custom domain (if applicable)
- [ ] Test site speed
- [ ] Submit sitemap to Google Search Console

### Post-Launch:
- [ ] Monitor GitHub Pages build status
- [ ] Check domain resolution
- [ ] Verify SSL certificate
- [ ] Test redirects
- [ ] Monitor analytics
- [ ] Check for broken links
- [ ] Update social media links

## 🔗 Important URLs

- **Website**: https://pinned.app (or your GitHub Pages URL)
- **Privacy Policy**: https://pinned.app/privacy.html
- **App Store**: https://pinned.app/app-store (redirects to App Store)
- **Support**: mailto:support@pinned.app

## 🛠 Troubleshooting

### Common Issues:

1. **Site not updating**: Clear browser cache, check GitHub Actions
2. **Images not loading**: Verify file paths and case sensitivity
3. **Custom domain not working**: Check DNS settings and CNAME file
4. **JavaScript errors**: Check browser console, test on different browsers

### GitHub Pages Specific:
- Build logs available in repository "Actions" tab
- Custom domains require HTTPS
- Some features may not work in preview mode

## 📄 License

Copyright © 2025 Aethon Labs. All rights reserved.

---

## 🎉 Ready to Launch!

Your Pinned website is now ready for deployment. The professional design and comprehensive features will help drive app downloads and user engagement.

**Key Features:**
- ✅ Mobile-first responsive design
- ✅ Fast loading and optimized
- ✅ SEO and accessibility compliant
- ✅ Interactive and engaging
- ✅ Professional branding
- ✅ Conversion optimized

Perfect for launching alongside your iOS app! 🚀