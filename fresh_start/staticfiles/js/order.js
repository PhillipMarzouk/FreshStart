document.addEventListener("DOMContentLoaded", function () {
    console.log("🔹 Order script loaded");

    const orderForm = document.getElementById("orderForm");

    if (!orderForm) {
        console.error("❌ Order form not found!");
        return;
    }

    function getMealType(item) {
        return item.getAttribute("data-meal-type") || "";
    }

    function isFieldTrip(item) {
        return item.getAttribute("data-is-field-trip") === "true";
    }


    function updateMealTypeLockouts() {
        const mealTypeCounts = {
            "Hot Meal": 0,
            "Hot Vegetarian": 0,
            "Cold Meal": 0,
            "Cold Vegetarian": 0
        };

        document.querySelectorAll(".menu-item").forEach(item => {
            const mealType = getMealType(item);
            const input = item.querySelector(".quantity-selector");
            const quantity = parseInt(input.value) || 0;

            if (!isFieldTrip(item) && mealType in mealTypeCounts) {
                mealTypeCounts[mealType] += quantity;
            }
        });

        document.querySelectorAll(".menu-item").forEach(item => {
            const mealType = getMealType(item);
            const input = item.querySelector(".quantity-selector");
            const quantity = parseInt(input.value) || 0;

            if (isFieldTrip(mealType) || !(mealType in mealTypeCounts)) {
                input.disabled = false;
                item.classList.remove("disabled");
                item.style.opacity = 1;
                return;
            }

            if (mealTypeCounts[mealType] > 0 && quantity === 0) {
                input.disabled = true;
                item.classList.add("disabled");
                item.style.opacity = 0.5;
            } else {
                input.disabled = false;
                item.classList.remove("disabled");
                item.style.opacity = 1;
            }
        });
    }

    document.querySelectorAll(".quantity-selector").forEach(input => {
        input.addEventListener("input", function () {
            let listItem = this.closest(".menu-item");
            let quantity = parseInt(this.value) || 0;

            if (quantity > 0) {
                listItem.classList.add("selected");
            } else {
                listItem.classList.remove("selected");
            }

            updateMealTypeLockouts();
        });

        let initialQuantity = parseInt(input.value) || 0;
        if (initialQuantity > 0) {
            input.closest(".menu-item").classList.add("selected");
        }
    });

    orderForm.addEventListener("submit", function (event) {
        const mealTypeCounts = {
            "Hot Meal": 0,
            "Hot Vegetarian": 0,
            "Cold Meal": 0,
            "Cold Vegetarian": 0
        };

        document.querySelectorAll(".menu-item").forEach(item => {
            const q = parseInt(item.querySelector(".quantity-selector").value) || 0;
            const type = getMealType(item);

            if (!isFieldTrip(type) && type in mealTypeCounts) {
                mealTypeCounts[type] += q;
            }
        });

        // ✅ Count how many different hot/cold meal types have a quantity > 0
        let hotCount = 0;
        let coldCount = 0;

        if (mealTypeCounts["Hot Meal"] > 0) hotCount++;
        if (mealTypeCounts["Hot Vegetarian"] > 0) hotCount++;
        if (mealTypeCounts["Cold Meal"] > 0) coldCount++;
        if (mealTypeCounts["Cold Vegetarian"] > 0) coldCount++;

        if (hotCount > 1 || coldCount > 1) {
            alert("You may only select one of each hot and one of each cold meal type.");
            event.preventDefault();
            return;
        }


        let selectedItems = [];
        let quantities = [];

        document.querySelectorAll(".menu-item").forEach(item => {
            let quantityInput = item.querySelector(".quantity-selector");
            let itemIdInput = item.querySelector("input[name='menu_items[]']");

            if (quantityInput && itemIdInput) {
                let quantity = parseInt(quantityInput.value);
                let itemId = itemIdInput.value;

                if (quantity > 0) {
                    selectedItems.push(itemId);
                    quantities.push(quantity);
                }
            }
        });

        if (selectedItems.length === 0) {
            alert("Please select at least one menu item with a Quantity above 0.");
            event.preventDefault();
            return;
        }

        console.log("✅ Selected Items:", selectedItems);
        console.log("✅ Selected Quantities:", quantities);

        document.querySelectorAll("input[name='menu_items[]'], input[name='quantities[]']").forEach(input => input.remove());

        selectedItems.forEach((itemId, index) => {
            let menuItemInput = document.createElement("input");
            menuItemInput.type = "hidden";
            menuItemInput.name = "menu_items[]";
            menuItemInput.value = itemId;

            let quantityInput = document.createElement("input");
            quantityInput.type = "hidden";
            quantityInput.name = "quantities[]";
            quantityInput.value = quantities[index];

            orderForm.appendChild(menuItemInput);
            orderForm.appendChild(quantityInput);
        });

        console.log("✅ Form data updated. Submitting...");
    });
});
