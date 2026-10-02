(function() {
    // Wait for DOM to be ready
    document.addEventListener('DOMContentLoaded', function() {
        
        // Restore saved theme
        const savedTheme = localStorage.getItem('theme');
        if (savedTheme === 'dark') {
            document.body.classList.add('dark-mode');
        }

        // Agar button already hai toh skip
        if (document.getElementById('themeToggle')) return;

        // Button create karo
        const btn = document.createElement('button');
        btn.id = 'themeToggle';
        btn.className = 'theme-toggle';
        btn.title = 'Toggle Dark Mode';
        updateIcon(btn);

        btn.addEventListener('click', function() {
            document.body.classList.toggle('dark-mode');
            localStorage.setItem('theme', 
                document.body.classList.contains('dark-mode') ? 'dark' : 'light'
            );
            updateIcon(btn);
        });

        document.body.appendChild(btn);
    });

    function updateIcon(btn) {
        if (document.body.classList.contains('dark-mode')) {
            btn.innerHTML = '<i class="fas fa-sun"></i>';
            btn.title = 'Switch to Light Mode';
        } else {
            btn.innerHTML = '<i class="fas fa-moon"></i>';
            btn.title = 'Switch to Dark Mode';
        }
    }
})();