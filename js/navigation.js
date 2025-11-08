class PageNavigation {
    constructor() {
        this.currentPage = 'page1';
        this.init();
    }

    init() {
        this.bindEvents();
    }

    bindEvents() {
        const page1Btn = document.getElementById('page1-btn');
        const page2Btn = document.getElementById('page2-btn');

        page1Btn.addEventListener('click', () => this.showPage('page1'));
        page2Btn.addEventListener('click', () => this.showPage('page2'));
    }

    showPage(pageId) {
        // Hide all pages
        const pages = document.querySelectorAll('.page');
        pages.forEach(page => page.classList.remove('active'));

        // Remove active class from all nav buttons
        const navBtns = document.querySelectorAll('.nav-btn');
        navBtns.forEach(btn => btn.classList.remove('active'));

        // Show selected page
        document.getElementById(pageId).classList.add('active');

        // Add active class to corresponding nav button
        document.getElementById(`${pageId}-btn`).classList.add('active');

        this.currentPage = pageId;
    }
}

// Initialize navigation when page loads
document.addEventListener('DOMContentLoaded', () => {
    window.pageNavigation = new PageNavigation();
});
