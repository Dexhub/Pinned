// Pinned Landing Page JavaScript
// Interactive features for the travel app website

class PinnedWebsite {
    constructor() {
        this.init();
    }

    init() {
        this.setupNavigation();
        this.setupScreenshotCarousel();
        this.setupScrollAnimations();
        this.setupSmoothScrolling();
        this.setupMobileMenu();
        this.setupFormHandling();
        this.setupAnalytics();
        this.setupAccessibility();
        this.setupPerformanceOptimizations();
    }

    // Navigation functionality
    setupNavigation() {
        const navbar = document.querySelector('.navbar');
        const navLinks = document.querySelectorAll('.nav-link');
        
        // Navbar scroll effect
        window.addEventListener('scroll', () => {
            if (window.scrollY > 50) {
                navbar.classList.add('scrolled');
            } else {
                navbar.classList.remove('scrolled');
            }
        });

        // Active link highlighting
        const sections = document.querySelectorAll('section[id]');
        window.addEventListener('scroll', () => {
            const scrollY = window.pageYOffset;
            
            sections.forEach(section => {
                const sectionHeight = section.offsetHeight;
                const sectionTop = section.offsetTop - 100;
                const sectionId = section.getAttribute('id');
                const correspondingLink = document.querySelector(`.nav-link[href="#${sectionId}"]`);
                
                if (scrollY > sectionTop && scrollY <= sectionTop + sectionHeight) {
                    navLinks.forEach(link => link.classList.remove('active'));
                    if (correspondingLink) {
                        correspondingLink.classList.add('active');
                    }
                }
            });
        });
    }

    // Screenshot carousel
    setupScreenshotCarousel() {
        const carousel = document.querySelector('.screenshots-carousel');
        const screenshots = document.querySelectorAll('.screenshot-item');
        const dots = document.querySelectorAll('.dot');
        let currentSlide = 0;
        let autoPlayInterval;

        const showSlide = (index) => {
            screenshots.forEach((screenshot, i) => {
                screenshot.classList.toggle('active', i === index);
            });
            
            dots.forEach((dot, i) => {
                dot.classList.toggle('active', i === index);
            });
            
            currentSlide = index;
        };

        const nextSlide = () => {
            const next = (currentSlide + 1) % screenshots.length;
            showSlide(next);
        };

        const prevSlide = () => {
            const prev = (currentSlide - 1 + screenshots.length) % screenshots.length;
            showSlide(prev);
        };

        // Dot navigation
        dots.forEach((dot, index) => {
            dot.addEventListener('click', () => {
                showSlide(index);
                resetAutoPlay();
            });
            
            // Keyboard support
            dot.addEventListener('keydown', (e) => {
                if (e.key === 'Enter' || e.key === ' ') {
                    e.preventDefault();
                    showSlide(index);
                    resetAutoPlay();
                }
            });
        });

        // Touch/swipe support
        let startX, startY, distX, distY;
        carousel?.addEventListener('touchstart', (e) => {
            startX = e.changedTouches[0].pageX;
            startY = e.changedTouches[0].pageY;
        });

        carousel?.addEventListener('touchend', (e) => {
            distX = e.changedTouches[0].pageX - startX;
            distY = e.changedTouches[0].pageY - startY;
            
            if (Math.abs(distX) > Math.abs(distY) && Math.abs(distX) > 50) {
                if (distX > 0) {
                    prevSlide();
                } else {
                    nextSlide();
                }
                resetAutoPlay();
            }
        });

        // Keyboard navigation
        document.addEventListener('keydown', (e) => {
            if (this.isInViewport(carousel)) {
                if (e.key === 'ArrowLeft') {
                    prevSlide();
                    resetAutoPlay();
                } else if (e.key === 'ArrowRight') {
                    nextSlide();
                    resetAutoPlay();
                }
            }
        });

        // Auto-play
        const startAutoPlay = () => {
            autoPlayInterval = setInterval(nextSlide, 5000);
        };

        const stopAutoPlay = () => {
            clearInterval(autoPlayInterval);
        };

        const resetAutoPlay = () => {
            stopAutoPlay();
            startAutoPlay();
        };

        // Pause on hover/focus
        carousel?.addEventListener('mouseenter', stopAutoPlay);
        carousel?.addEventListener('mouseleave', startAutoPlay);
        carousel?.addEventListener('focusin', stopAutoPlay);
        carousel?.addEventListener('focusout', startAutoPlay);

        // Respect reduced motion preference
        if (!window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
            startAutoPlay();
        }
    }

    // Scroll animations
    setupScrollAnimations() {
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('animate-in');
                }
            });
        }, observerOptions);

        // Observe elements for animation
        const animatedElements = document.querySelectorAll(`
            .feature-card,
            .personality-type,
            .hero-stats .stat,
            .floating-card
        `);

        animatedElements.forEach(el => {
            observer.observe(el);
        });

        // Counter animation
        this.setupCounterAnimations();
    }

    setupCounterAnimations() {
        const counters = document.querySelectorAll('.stat-number');
        const counterObserver = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    this.animateCounter(entry.target);
                    counterObserver.unobserve(entry.target);
                }
            });
        });

        counters.forEach(counter => counterObserver.observe(counter));
    }

    animateCounter(element) {
        const text = element.textContent;
        const target = text === '∞' ? '∞' : parseInt(text);
        
        if (target === '∞') return;
        
        const duration = 2000;
        const start = performance.now();
        const startValue = 0;

        const animate = (currentTime) => {
            const elapsed = currentTime - start;
            const progress = Math.min(elapsed / duration, 1);
            
            const easeOutCubic = 1 - Math.pow(1 - progress, 3);
            const current = Math.floor(startValue + (target - startValue) * easeOutCubic);
            
            element.textContent = current.toString();
            
            if (progress < 1) {
                requestAnimationFrame(animate);
            } else {
                element.textContent = target.toString();
            }
        };

        requestAnimationFrame(animate);
    }

    // Smooth scrolling
    setupSmoothScrolling() {
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', (e) => {
                e.preventDefault();
                const target = document.querySelector(anchor.getAttribute('href'));
                
                if (target) {
                    const offsetTop = target.offsetTop - 80; // Account for fixed navbar
                    
                    window.scrollTo({
                        top: offsetTop,
                        behavior: 'smooth'
                    });
                }
            });
        });
    }

    // Mobile menu
    setupMobileMenu() {
        const hamburger = document.querySelector('.hamburger');
        const navMenu = document.querySelector('.nav-menu');
        const navLinks = document.querySelectorAll('.nav-link');

        hamburger?.addEventListener('click', () => {
            navMenu?.classList.toggle('active');
            hamburger.classList.toggle('active');
            document.body.classList.toggle('menu-open');
        });

        // Close menu when clicking on links
        navLinks.forEach(link => {
            link.addEventListener('click', () => {
                navMenu?.classList.remove('active');
                hamburger?.classList.remove('active');
                document.body.classList.remove('menu-open');
            });
        });

        // Close menu when clicking outside
        document.addEventListener('click', (e) => {
            if (!e.target.closest('.navbar')) {
                navMenu?.classList.remove('active');
                hamburger?.classList.remove('active');
                document.body.classList.remove('menu-open');
            }
        });

        // Handle escape key
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape') {
                navMenu?.classList.remove('active');
                hamburger?.classList.remove('active');
                document.body.classList.remove('menu-open');
            }
        });
    }

    // Form handling (for future contact forms)
    setupFormHandling() {
        const forms = document.querySelectorAll('form');
        
        forms.forEach(form => {
            form.addEventListener('submit', (e) => {
                e.preventDefault();
                this.handleFormSubmission(form);
            });
        });
    }

    handleFormSubmission(form) {
        const formData = new FormData(form);
        const data = Object.fromEntries(formData);
        
        // Show loading state
        const submitButton = form.querySelector('button[type="submit"]');
        const originalText = submitButton?.textContent;
        if (submitButton) {
            submitButton.disabled = true;
            submitButton.textContent = 'Sending...';
        }

        // Simulate form submission (replace with actual endpoint)
        setTimeout(() => {
            if (submitButton) {
                submitButton.disabled = false;
                submitButton.textContent = originalText;
            }
            
            this.showNotification('Thank you for your interest! We\'ll be in touch soon.', 'success');
            form.reset();
        }, 2000);
    }

    // Analytics and tracking
    setupAnalytics() {
        // Track button clicks
        document.querySelectorAll('.btn, .download-button').forEach(button => {
            button.addEventListener('click', (e) => {
                const buttonText = e.target.textContent?.trim() || 'Unknown';
                const buttonHref = e.target.href || 'No URL';
                
                this.trackEvent('Button Click', {
                    button_text: buttonText,
                    button_url: buttonHref,
                    page_location: window.location.href
                });
            });
        });

        // Track scroll depth
        let maxScrollDepth = 0;
        window.addEventListener('scroll', this.throttle(() => {
            const scrollDepth = Math.round((window.scrollY / (document.body.scrollHeight - window.innerHeight)) * 100);
            
            if (scrollDepth > maxScrollDepth) {
                maxScrollDepth = scrollDepth;
                
                // Track at 25%, 50%, 75%, and 100%
                if ([25, 50, 75, 100].includes(scrollDepth)) {
                    this.trackEvent('Scroll Depth', {
                        depth: scrollDepth,
                        page_location: window.location.href
                    });
                }
            }
        }, 1000));

        // Track time on page
        const startTime = Date.now();
        window.addEventListener('beforeunload', () => {
            const timeOnPage = Math.round((Date.now() - startTime) / 1000);
            this.trackEvent('Time on Page', {
                duration: timeOnPage,
                page_location: window.location.href
            });
        });
    }

    trackEvent(eventName, properties = {}) {
        // Integration with analytics services
        if (typeof gtag !== 'undefined') {
            gtag('event', eventName, properties);
        }
        
        if (typeof plausible !== 'undefined') {
            plausible(eventName, { props: properties });
        }
        
        console.log('Event tracked:', eventName, properties);
    }

    // Accessibility improvements
    setupAccessibility() {
        // Keyboard navigation for carousel
        document.addEventListener('keydown', (e) => {
            if (e.target.classList.contains('dot')) {
                if (e.key === 'ArrowLeft' || e.key === 'ArrowRight') {
                    e.preventDefault();
                    const dots = Array.from(document.querySelectorAll('.dot'));
                    const currentIndex = dots.indexOf(e.target);
                    let nextIndex;
                    
                    if (e.key === 'ArrowLeft') {
                        nextIndex = currentIndex > 0 ? currentIndex - 1 : dots.length - 1;
                    } else {
                        nextIndex = currentIndex < dots.length - 1 ? currentIndex + 1 : 0;
                    }
                    
                    dots[nextIndex].focus();
                    dots[nextIndex].click();
                }
            }
        });

        // Skip link for keyboard users
        this.addSkipLink();
        
        // Focus management
        this.setupFocusManagement();
    }

    addSkipLink() {
        const skipLink = document.createElement('a');
        skipLink.href = '#main-content';
        skipLink.textContent = 'Skip to main content';
        skipLink.className = 'skip-link sr-only';
        skipLink.style.cssText = `
            position: absolute;
            top: -40px;
            left: 6px;
            background: var(--primary-color);
            color: white;
            padding: 8px;
            text-decoration: none;
            border-radius: 4px;
            z-index: 1000;
            transition: top 0.3s;
        `;
        
        skipLink.addEventListener('focus', () => {
            skipLink.style.top = '6px';
            skipLink.classList.remove('sr-only');
        });
        
        skipLink.addEventListener('blur', () => {
            skipLink.style.top = '-40px';
            skipLink.classList.add('sr-only');
        });
        
        document.body.insertBefore(skipLink, document.body.firstChild);
        
        // Add id to main content
        const heroSection = document.querySelector('.hero');
        if (heroSection) {
            heroSection.id = 'main-content';
        }
    }

    setupFocusManagement() {
        // Trap focus in mobile menu when open
        const navbar = document.querySelector('.navbar');
        const focusableElements = 'a[href], button, textarea, input[type="text"], input[type="radio"], input[type="checkbox"], select';
        
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Tab' && document.body.classList.contains('menu-open')) {
                const focusableContent = navbar?.querySelectorAll(focusableElements);
                const firstFocusableElement = focusableContent?.[0];
                const lastFocusableElement = focusableContent?.[focusableContent.length - 1];

                if (e.shiftKey) {
                    if (document.activeElement === firstFocusableElement) {
                        lastFocusableElement?.focus();
                        e.preventDefault();
                    }
                } else {
                    if (document.activeElement === lastFocusableElement) {
                        firstFocusableElement?.focus();
                        e.preventDefault();
                    }
                }
            }
        });
    }

    // Performance optimizations
    setupPerformanceOptimizations() {
        // Lazy load images
        this.lazyLoadImages();
        
        // Preload critical resources
        this.preloadCriticalResources();
        
        // Optimize scroll performance
        this.optimizeScrollPerformance();
    }

    lazyLoadImages() {
        const images = document.querySelectorAll('img[data-src]');
        const imageObserver = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const img = entry.target;
                    img.src = img.dataset.src;
                    img.classList.remove('lazy');
                    imageObserver.unobserve(img);
                }
            });
        });

        images.forEach(img => imageObserver.observe(img));
    }

    preloadCriticalResources() {
        // Preload key images
        const criticalImages = [
            'assets/hero-phone.png',
            'assets/logo.svg'
        ];

        criticalImages.forEach(src => {
            const link = document.createElement('link');
            link.rel = 'preload';
            link.as = 'image';
            link.href = src;
            document.head.appendChild(link);
        });
    }

    optimizeScrollPerformance() {
        let ticking = false;
        
        const handleScroll = () => {
            if (!ticking) {
                requestAnimationFrame(() => {
                    // Scroll-based animations
                    this.updateScrollProgress();
                    ticking = false;
                });
                ticking = true;
            }
        };

        window.addEventListener('scroll', handleScroll, { passive: true });
    }

    updateScrollProgress() {
        const scrollProgress = window.scrollY / (document.documentElement.scrollHeight - window.innerHeight);
        document.documentElement.style.setProperty('--scroll-progress', scrollProgress);
    }

    // Utility functions
    throttle(func, limit) {
        let inThrottle;
        return function() {
            const args = arguments;
            const context = this;
            if (!inThrottle) {
                func.apply(context, args);
                inThrottle = true;
                setTimeout(() => inThrottle = false, limit);
            }
        };
    }

    isInViewport(element) {
        const rect = element?.getBoundingClientRect();
        return rect && (
            rect.top >= 0 &&
            rect.left >= 0 &&
            rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) &&
            rect.right <= (window.innerWidth || document.documentElement.clientWidth)
        );
    }

    showNotification(message, type = 'info') {
        const notification = document.createElement('div');
        notification.className = `notification notification-${type}`;
        notification.textContent = message;
        notification.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            background: ${type === 'success' ? '#10b981' : type === 'error' ? '#ef4444' : '#3b82f6'};
            color: white;
            padding: 16px 24px;
            border-radius: 8px;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
            z-index: 1000;
            animation: slideIn 0.3s ease-out;
        `;
        
        document.body.appendChild(notification);
        
        setTimeout(() => {
            notification.style.animation = 'slideOut 0.3s ease-in forwards';
            setTimeout(() => notification.remove(), 300);
        }, 5000);
    }
}

// Initialize the website when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    new PinnedWebsite();
});

// Add CSS animations
const style = document.createElement('style');
style.textContent = `
    @keyframes slideIn {
        from {
            transform: translateX(100%);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }
    
    @keyframes slideOut {
        from {
            transform: translateX(0);
            opacity: 1;
        }
        to {
            transform: translateX(100%);
            opacity: 0;
        }
    }
    
    .animate-in {
        animation: fadeInUp 0.6s ease-out forwards;
    }
    
    @keyframes fadeInUp {
        from {
            opacity: 0;
            transform: translateY(30px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
    
    .navbar.scrolled {
        background: rgba(255, 255, 255, 0.98);
        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
    }
    
    @media (max-width: 767px) {
        .nav-menu {
            position: fixed;
            left: -100%;
            top: 70px;
            flex-direction: column;
            background-color: white;
            width: 100%;
            text-align: center;
            transition: 0.3s;
            box-shadow: 0 10px 27px rgba(0, 0, 0, 0.05);
            padding: 2rem 0;
        }
        
        .nav-menu.active {
            left: 0;
        }
        
        .hamburger.active span:nth-child(2) {
            opacity: 0;
        }
        
        .hamburger.active span:nth-child(1) {
            transform: translateY(7px) rotate(45deg);
        }
        
        .hamburger.active span:nth-child(3) {
            transform: translateY(-7px) rotate(-45deg);
        }
        
        body.menu-open {
            overflow: hidden;
        }
    }
`;
document.head.appendChild(style);