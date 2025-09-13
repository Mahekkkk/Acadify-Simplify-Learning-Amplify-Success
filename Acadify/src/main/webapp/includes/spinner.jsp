<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="page" value="spinner" />

<style>
.global-loader {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(255,255,255,0.8);
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 9999;
    transition: opacity 0.3s ease-out;
}
.global-loader.hide {
    opacity: 0;
    pointer-events: none;
}
.spinner {
    width: 50px;
    height: 50px;
    border-radius: 50%;
    animation: spin 1s linear infinite;
    border: 4px solid <c:out value="${param.bgColor}" default="#f3f3f3"/>;
    border-top: 4px solid <c:out value="${param.color}" default="#3498db"/>;
}
@keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
}
.spinner-container {
    text-align: center;
    animation: fadeIn 0.5s ease-out;
}
@keyframes fadeIn {
    from { opacity: 0; transform: translateY(10px); }
    to { opacity: 1; transform: translateY(0); }
}
.loading-text {
    margin-top: 15px;
    font-family: Arial, sans-serif;
    color: <c:out value="${param.color}" default="#3498db"/>;
}
</style>

<div class="global-loader" id="globalLoader">
    <div class="spinner-container">
        <div class="spinner"></div>
        <p class="loading-text">
            <c:out value="${param.text}" default="Loading your content..."/>
        </p>
    </div>
</div>

<script>
window.addEventListener('load', function() {
    const loader = document.getElementById('globalLoader');
    if (loader) {
        loader.classList.add('hide');
        setTimeout(() => loader.remove(), 300);
    }
});
</script>
