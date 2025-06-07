document.addEventListener("DOMContentLoaded", function () {
    console.log("🔹 Checkout validation script loaded"); // ✅ Debugging log

    const checkoutForm = document.querySelector("form[action='{% url 'checkout' %}']");
    
    if (!checkoutForm) {
        console.error("❌ Checkout form not found!");
        return;
    }

    checkoutForm.addEventListener("submit", function (event) {
        console.log("🔹 Checkout form submitted"); // ✅ Debugging log

        let cartByDate = {};

        document.querySelectorAll(".menu-item").forEach(item => {
            let date = item.getAttribute("data-date");
            let portions = item.getAttribute("data-portions") ? item.getAttribute("data-portions").split(",") : [];
            let quantityInput = item.querySelector(".quantity-selector");

            if (!quantityInput) {
                console.error(`❌ No quantity input found for item ${item}`);
                return;
            }

            let quantity = parseInt(quantityInput.value) || 0;

            if (!cartByDate[date]) {
                cartByDate[date] = { Protein: 0, Grain: 0, Vegetable: 0, Fruit: 0 };
            }

            if (quantity > 0) {
                portions.forEach(portion => {
                    if (cartByDate[date][portion] !== undefined) {
                        cartByDate[date][portion] += 1;
                    }
                });
            }
        });

        console.log("🔹 Processed Cart Data:", cartByDate); // ✅ Debugging log

        for (let date in cartByDate) {
            let portions = cartByDate[date];
            console.log(`🔹 Checking portions for ${date}:`, portions);

            if (portions.Protein === 0 || portions.Grain === 0 || portions.Vegetable === 0 || portions.Fruit === 0) {
                alert(`Your order for ${date} must include at least one Protein, Grain, Vegetable, and Fruit.`);
                event.preventDefault();  // ✅ Stop form submission
                return;
            }
        }

        console.log("✅ Order passes validation. Proceeding to checkout.");
    });
});
