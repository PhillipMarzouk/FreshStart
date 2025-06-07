document.addEventListener("DOMContentLoaded", function () {
    console.log("🚀 export_production.js loaded!");

    let container = document.querySelector(".object-tools");

    if (container) {
        let listItem = document.createElement("li");

        // ✅ Create Date Input
        let dateInput = document.createElement("input");
        dateInput.type = "date";
        dateInput.id = "export-date";
        dateInput.style.marginRight = "10px";

        // ✅ Create Export Button
        let exportButton = document.createElement("a");
        exportButton.innerText = "Export Production Sheet";
        exportButton.classList.add("button");
        exportButton.href = "#";
        exportButton.style.backgroundColor = "#72bc0a";
        exportButton.style.color = "white";
        exportButton.style.border = "none";
        exportButton.style.padding = "5px 10px";
        exportButton.style.marginRight = "10px";
        exportButton.style.borderRadius = "20px"; // ✅ Match button styling
        exportButton.style.fontWeight = "bold";

        exportButton.addEventListener("click", function (e) {
            e.preventDefault();
            let selectedDate = dateInput.value;
            if (!selectedDate) {
                alert("Please select a date before exporting.");
                return;
            }
            console.log(`📅 Exporting for date: ${selectedDate}`);
            window.location.href = `/admin/food_order_api/userorder/export-excel/?date=${selectedDate}`;
        });

        // ✅ Wrap Elements Inside `<li>` (Ensures Correct Order)
        listItem.appendChild(exportButton);
        listItem.appendChild(dateInput);
        container.prepend(listItem);

        console.log("✅ Export button added successfully!");
    } else {
        console.warn("⚠️ Could not find .object-tools container in Admin UI!");
    }
});
