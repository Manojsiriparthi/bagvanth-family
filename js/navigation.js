document.addEventListener('DOMContentLoaded', function() {
    // Navigation functionality
    const page1Btn = document.getElementById('page1-btn');
    const page2Btn = document.getElementById('page2-btn');

    if (page1Btn) {
        page1Btn.addEventListener('click', function() {
            showPage('page1');
            setActiveButton('page1-btn');
        });
    }

    if (page2Btn) {
        page2Btn.addEventListener('click', function() {
            showPage('page2');
            setActiveButton('page2-btn');
        });
    }

    function showPage(pageId) {
        const pages = document.querySelectorAll('.page');
        pages.forEach(page => {
            page.classList.remove('active');
        });
        
        const targetPage = document.getElementById(pageId);
        if (targetPage) {
            targetPage.classList.add('active');
        }
    }

    function setActiveButton(buttonId) {
        const buttons = document.querySelectorAll('.nav-btn');
        buttons.forEach(btn => {
            btn.classList.remove('active');
        });
        
        const targetButton = document.getElementById(buttonId);
        if (targetButton) {
            targetButton.classList.add('active');
        }
    }
});
