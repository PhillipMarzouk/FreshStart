document.addEventListener("DOMContentLoaded", function () {
    const dropdown = document.querySelector(".dropdown");
    const dropdownButton = document.querySelector("#dropdownButton");
    const dropdownMenu = document.querySelector("#dropdownMenu");
    const selectedInput = document.querySelector("#selectedProgram");
    const dropdownText = document.querySelector("#dropdownText");

    // ✅ Prevents dropdown from closing instantly
    dropdownButton.addEventListener("click", function (event) {
        event.stopPropagation();  // ✅ Prevents event bubbling
        dropdown.classList.toggle("open");
    });

    // ✅ Update selected item in dropdown
    dropdownMenu.addEventListener("click", function (event) {
        event.stopPropagation();  // ✅ Ensures dropdown stays open while selecting
        if (event.target.tagName === "LI") {
            const selectedValue = event.target.getAttribute("data-value");
            dropdownText.textContent = event.target.textContent;  // ✅ Update dropdown text
            selectedInput.value = selectedValue;
            dropdown.classList.remove("open");  // ✅ Close dropdown after selection
        }
    });

    // ✅ Close dropdown when clicking outside
    document.addEventListener("click", function (event) {
        if (!dropdown.contains(event.target)) {
            dropdown.classList.remove("open");
        }
    });
});
