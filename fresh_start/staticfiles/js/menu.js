document.addEventListener("DOMContentLoaded", function() {
    const sidebar = document.querySelector(".sidebar");
    const mainContent = document.querySelector(".main-content");
    const menuToggle = document.getElementById("menu-toggle");
    const icon = menuToggle.querySelector("i");

    // ✅ Function to collapse or expand sidebar based on screen width
    function updateSidebarState() {
        if (window.innerWidth < 1024) {
            sidebar.classList.add("collapsed");
            mainContent.classList.add("menu-collapsed");
            icon.classList.remove("fa-chevron-left");
            icon.classList.add("fa-chevron-right");
            localStorage.setItem("sidebarState", "collapsed"); // ✅ Save state
        } else {
            // ✅ Restore last saved state on larger screens
            if (localStorage.getItem("sidebarState") === "collapsed") {
                sidebar.classList.add("collapsed");
                mainContent.classList.add("menu-collapsed");
                icon.classList.remove("fa-chevron-left");
                icon.classList.add("fa-chevron-right");
            } else {
                sidebar.classList.remove("collapsed");
                mainContent.classList.remove("menu-collapsed");
                icon.classList.remove("fa-chevron-right");
                icon.classList.add("fa-chevron-left");
            }
        }
    }

    // ✅ Run on page load
    updateSidebarState();

    // ✅ Run on window resize
    window.addEventListener("resize", updateSidebarState);

    // ✅ Toggle sidebar on button click
    menuToggle.addEventListener("click", function() {
        sidebar.classList.toggle("collapsed");
        mainContent.classList.toggle("menu-collapsed");

        if (sidebar.classList.contains("collapsed")) {
            icon.classList.remove("fa-chevron-left");
            icon.classList.add("fa-chevron-right");
            localStorage.setItem("sidebarState", "collapsed");
        } else {
            icon.classList.remove("fa-chevron-right");
            icon.classList.add("fa-chevron-left");
            localStorage.setItem("sidebarState", "expanded");
        }
    });
});
