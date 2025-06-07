document.addEventListener("DOMContentLoaded", function () {
    console.log("🔹 Order script loaded"); // ✅ Debugging log

    const orderForm = document.getElementById("orderForm");

    if (!orderForm) {
        console.error("❌ Order form not found!");
        return;
    }

    // ✅ Handle quantity changes to update item selection & styling
    document.querySelectorAll(".quantity-selector").forEach(input => {
        input.addEventListener("input", function () {
            let listItem = this.closest(".menu-item"); // ✅ Get the closest <li> parent
            let quantity = parseInt(this.value) || 0; // ✅ Convert value to number

            if (quantity > 0) {
                listItem.classList.add("selected"); // ✅ Add green background
            } else {
                listItem.classList.remove("selected"); // ✅ Remove green background
            }
        });

        // ✅ Ensure styling applies on page load if values were saved
        let initialQuantity = parseInt(input.value) || 0;
        if (initialQuantity > 0) {
            input.closest(".menu-item").classList.add("selected");
        }
    });

    // ✅ Handle form submission
    orderForm.addEventListener("submit", function (event) {
        event.preventDefault(); // ✅ Prevent default submission

        let selectedItems = [];
        let quantities = [];

        document.querySelectorAll(".menu-item").forEach(item => {
            let quantityInput = item.querySelector(".quantity-selector");
            let itemIdInput = item.querySelector("input[name='menu_items[]']"); // ✅ Use array notation

            if (quantityInput && itemIdInput) {
                let quantity = parseInt(quantityInput.value);
                let itemId = itemIdInput.value;

                if (quantity > 0) { // ✅ Only add items with quantity > 0
                    selectedItems.push(itemId);
                    quantities.push(quantity);
                }
            }
        });

        if (selectedItems.length === 0) {
            alert("Please select at least one menu item with a Quantity above 0.");
            return;
        }

        console.log("✅ Selected Items:", selectedItems);
        console.log("✅ Selected Quantities:", quantities);

        // ✅ Remove old hidden inputs before adding new ones
        document.querySelectorAll("input[name='menu_items[]'], input[name='quantities[]']").forEach(input => input.remove());

        // ✅ Create hidden input fields to store selected items
        selectedItems.forEach((itemId, index) => {
            let menuItemInput = document.createElement("input");
            menuItemInput.type = "hidden";
            menuItemInput.name = "menu_items[]"; // ✅ Correctly named for multiple values
            menuItemInput.value = itemId;

            let quantityInput = document.createElement("input");
            quantityInput.type = "hidden";
            quantityInput.name = "quantities[]"; // ✅ Correctly named for multiple values
            quantityInput.value = quantities[index];

            orderForm.appendChild(menuItemInput);
            orderForm.appendChild(quantityInput);
        });

        console.log("✅ Form data updated. Submitting...");
        orderForm.submit(); // ✅ Submit form after fixing inputs
    });
});
