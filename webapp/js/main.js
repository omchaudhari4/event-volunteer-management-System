// Interactive UI Helpers: Modal Controls, Dynamic Table Filtering, Button Ripple & Animations

document.addEventListener('DOMContentLoaded', () => {
    // 1. Ripple Effect on Buttons
    document.querySelectorAll('.btn, .demo-chip').forEach(button => {
        button.addEventListener('click', function (e) {
            const ripple = document.createElement('span');
            const rect = this.getBoundingClientRect();
            const size = Math.max(rect.width, rect.height);
            const x = e.clientX - rect.left - size / 2;
            const y = e.clientY - rect.top - size / 2;

            ripple.style.width = ripple.style.height = `${size}px`;
            ripple.style.left = `${x}px`;
            ripple.style.top = `${y}px`;
            ripple.style.position = 'absolute';
            ripple.style.borderRadius = '50%';
            ripple.style.background = 'rgba(255, 255, 255, 0.35)';
            ripple.style.transform = 'scale(0)';
            ripple.style.animation = 'rippleAnim 0.6s linear';
            ripple.style.pointerEvents = 'none';

            this.appendChild(ripple);

            setTimeout(() => {
                ripple.remove();
            }, 600);
        });
    });

    // Add ripple animation keyframes dynamically if not existing
    if (!document.getElementById('ripple-style')) {
        const style = document.createElement('style');
        style.id = 'ripple-style';
        style.textContent = `
            @keyframes rippleAnim {
                to {
                    transform: scale(2.5);
                    opacity: 0;
                }
            }
        `;
        document.head.appendChild(style);
    }

    // 2. Live Table Search Filter with smooth fade
    const searchInputs = document.querySelectorAll('[data-table-search]');
    searchInputs.forEach(input => {
        const targetTableId = input.getAttribute('data-table-search');
        const table = document.getElementById(targetTableId);
        if (!table) return;

        input.addEventListener('input', (e) => {
            const query = e.target.value.toLowerCase().trim();
            const rows = table.querySelectorAll('tbody tr');

            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                if (text.includes(query)) {
                    row.style.display = '';
                    row.style.animation = 'fadeInUp 0.25s ease-out';
                } else {
                    row.style.display = 'none';
                }
            });
        });
    });

    // 3. Status Filter Tabs
    const filterTabs = document.querySelectorAll('[data-status-filter]');
    filterTabs.forEach(tab => {
        tab.addEventListener('click', (e) => {
            e.preventDefault();
            filterTabs.forEach(t => t.classList.remove('active'));
            tab.classList.add('active');

            const filterValue = tab.getAttribute('data-status-filter');
            const targetTableId = tab.getAttribute('data-target-table');
            const table = document.getElementById(targetTableId);
            if (!table) return;

            const rows = table.querySelectorAll('tbody tr');
            rows.forEach(row => {
                if (filterValue === 'all' || row.getAttribute('data-status') === filterValue) {
                    row.style.display = '';
                    row.style.animation = 'fadeInUp 0.25s ease-out';
                } else {
                    row.style.display = 'none';
                }
            });
        });
    });

    // 4. Modal Opening & Closing
    const modalTriggers = document.querySelectorAll('[data-modal-target]');
    modalTriggers.forEach(btn => {
        btn.addEventListener('click', () => {
            const targetModalId = btn.getAttribute('data-modal-target');
            const modal = document.getElementById(targetModalId);
            if (modal) {
                modal.classList.add('open');
            }
        });
    });

    const modalCloses = document.querySelectorAll('.modal-close, [data-modal-close]');
    modalCloses.forEach(btn => {
        btn.addEventListener('click', () => {
            const modal = btn.closest('.modal-overlay');
            if (modal) {
                modal.classList.remove('open');
            }
        });
    });

    // Close modal on clicking backdrop
    document.querySelectorAll('.modal-overlay').forEach(overlay => {
        overlay.addEventListener('click', (e) => {
            if (e.target === overlay) {
                overlay.classList.remove('open');
            }
        });
    });

    // 5. Auto Fade-Out Alerts after 5 seconds
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(alert => {
        setTimeout(() => {
            alert.style.transition = 'all 0.5s ease';
            alert.style.opacity = '0';
            alert.style.transform = 'translateY(-10px)';
            setTimeout(() => alert.remove(), 500);
        }, 5000);
    });
});
