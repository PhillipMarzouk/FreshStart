document.addEventListener("DOMContentLoaded", function () {
    let container = document.querySelector(".object-tools");

    if (container) {
        let dateInput = document.createElement("input");
        dateInput.type = "date";
        dateInput.id = "export-date";
        dateInput.style.marginRight = "10px";

        let exportButton = document.createElement("a");
        exportButton.innerText = "Export Production Sheet";
        exportButton.classList.add("button");
        exportButton.href = "#";
        exportButton.style.backgroundColor = "#72bc0a";
        exportButton.style.color = "white";
        exportButton.style.border = "none";
        exportButton.style.padding = "5px 10px";

        exportButton.addEventListener("click", function (e) {
            e.preventDefault();
            let selectedDate = dateInput.value;
            if (!selectedDate) {
                alert("Please select a date before exporting.");
                return;
            }
            window.location.href = `/admin/food_order_api/userorder/export-excel/?date=${selectedDate}`;
        });

        container.prepend(dateInput);
        container.prepend(exportButton);
    }
});
