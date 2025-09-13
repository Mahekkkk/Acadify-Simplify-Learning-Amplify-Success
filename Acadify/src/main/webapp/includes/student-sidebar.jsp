<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!-- Sidebar Toggle Button -->
<button class="sidebar-toggle" onclick="toggleSidebar()" aria-label="Toggle navigation">
    <span class="hamburger-box">
        <span class="hamburger-inner"></span>
    </span>
</button>

<nav id="main-sidebar" class="sidebar <c:if test='${param.sidebarClosed eq "true"}'>collapsed</c:if>">
    <div class="sidebar-header">
        <h2>Acadify</h2>
    </div>
    
    <div class="sidebar-menu">
        <a href="${pageContext.request.contextPath}/dashboard" class="${page eq 'dashboard' ? 'active' : ''}">
            <i class="fas fa-tachometer-alt"></i>
            <span>Dashboard</span>
        </a>
        <a href="${pageContext.request.contextPath}/student/AddCourseServlet" class="${page eq 'courses' ? 'active' : ''}">
            <i class="fas fa-book"></i>
            <span>Courses</span>
        </a>
        <a href="${pageContext.request.contextPath}/assignments" class="${page eq 'assignments' ? 'active' : ''}">
            <i class="fas fa-tasks"></i>
            <span>Assignments</span>
        </a>
        <a href="${pageContext.request.contextPath}/grades" class="${page eq 'grades' ? 'active' : ''}">
            <i class="fas fa-chart-line"></i>
            <span>Grades</span>
        </a>
        <a href="${pageContext.request.contextPath}/profile" class="${page eq 'profile' ? 'active' : ''}">
            <i class="fas fa-user"></i>
            <span>Profile</span>
        </a>
    </div>
    
    <div class="sidebar-footer">
        <a href="${pageContext.request.contextPath}/logout">
            <i class="fas fa-sign-out-alt"></i>
            <span>Logout</span>
        </a>
    </div>
</nav>
<script>
function toggleSidebar() {
    const sidebar = document.querySelector('.sidebar');
    const toggleBtn = document.querySelector('.sidebar-toggle');
    
    sidebar.classList.toggle('collapsed');
    toggleBtn.classList.toggle('is-active');
    
    // Save state in localStorage
    localStorage.setItem('sidebarCollapsed', sidebar.classList.contains('collapsed'));
    
    // Dispatch event for other components
    document.dispatchEvent(new Event('sidebarToggled'));
}

// Load saved state
document.addEventListener('DOMContentLoaded', function() {
    const savedState = localStorage.getItem('sidebarCollapsed');
    if (savedState === 'true') {
        document.querySelector('.sidebar').classList.add('collapsed');
    } else if (savedState === 'false') {
        document.querySelector('.sidebar').classList.remove('collapsed');
    }
    
    // Add event listener for responsive behavior
    window.addEventListener('resize', checkSidebarState);
    checkSidebarState();
});

function checkSidebarState() {
    if (window.innerWidth <= 768) {
        document.querySelector('.sidebar').classList.add('collapsed');
    }
}
</script>