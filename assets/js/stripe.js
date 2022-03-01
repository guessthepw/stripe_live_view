import topbar from "../vendor/topbar";
/*
 *  Hooks.StripeHook
 */
export const StripeHook = {
  mounted() {
    /*
     * Stripe implementation starts here.
     * 1) Get publishable_key from form
     */
    const stripe = Stripe(this.el.dataset.publicKey);
    /*
     * 2) Set options for Stripe.js
     *  A) `clientSecret` - secret key for setupIntent (can only add a payment method with this)
     *  B) `appearance` - custom CSS rules for stripe generated form inputs.
     */
    const options = {
      clientSecret: this.el.dataset.clientSecret,
      appearance: {
        theme: "stripe",
        rules: {
          ".Label": {
            color: "#374151",
            fontFamily: "inherit",
            marginBottom: "5px",
            fontWeight: "700",
            fontSize: "0.875rem",
            lineHeight: "1.25rem",
          },
          ".Input": {
            fontSize: "1em",
            borderRadius: "0.25rem",
            lineHeight: "1.25",
            color: "#000000",
            fontFamily: "inherit",
            fontWeight: "500",
            paddingLeft: "0.75rem",
            paddingRight: "0.75rem",
            paddingTop: "0.5rem",
            paddingBottom: "0.5rem",
            boxShadow:
              "var(--tw-ring-offset-shadow, 0 0 #0000), var(--tw-ring-shadow, 0 0 #0000), var(--tw-shadow)",
          },
          ".Error": {
            fontSize: "11px",
            marginTop: "5px",
            marginLeft: "10px",
            color: "#ef0f0f",
            fontFamily: "var(--font-family)",
          },
        },
      },
    };

    /*
     * 3) Set up Stripe.js and Elements to use in onboarding form, passing
     * the client secret obtained when creating the setup intent on the backend
     */
    const elements = stripe.elements(options);

    /*
     * 4) Create and mount the Payment Element, Ignore the billing details
     * because we are already collecting them
     */
    const payment = elements.create("payment");
    payment.mount("#card-element");

    /*
     * 5) Listen for submit on billing form.
     */
    const messageContainer = document.querySelector("#card-errors");

    /*
     * If this a re-occurring subscription we use a setup intent
     */
    this.el.addEventListener("submit", async (event) => {
      event.preventDefault();
      messageContainer.textContent = "";
      buttonText = document.getElementById('button-text');
      buttonText.textContent = "Processing...";

      topbar.show();
      const { setup_error } = await stripe.confirmSetup({
        // Wait for stripe confirmation
        elements,
        confirmParams: {
          return_url: window.location.href,
          payment_method_data: {
            billing_details: {
              name: event.target.elements.card_name.value,
            },
          },
        },
        redirect: "if_required", // Only redirect if the payment method requires it
      });
      /*
       * 6) If there is an error, display it. Otherwise push `intent-confirmed`
       *    event.
       */
      if (setup_error) {
        /*
         * This point will only be reached if there is an immediate error when
         * confirming the payment.
         */
        topbar.hide();
        buttonText.textContent = "Pay";
        messageContainer.textContent = error.message; // Set error message
      } else {
        /*
         * Your customer will be redirected to your `return_url`. For some payment
         * methods like iDEAL, your customer will be redirected to an intermediate
         * site first to authorize the payment, then redirected to the `return_url`.
         */
        stripe
          .retrieveSetupIntent(this.el.dataset.clientSecret)
          .then(({ setupIntent }) => {
            /*
             * Inspect the SetupIntent `status` to indicate the status of the payment
             * to your customer.
             *
             * Some payment methods will [immediately succeed or fail][0] upon
             * confirmation, while others will first enter a `processing` state.
             *
             * [0]: https://stripe.com/docs/payments/payment-methods#payment-notification
             */
            switch (setupIntent.status) {
              case "succeeded": {
                this.pushEvent("payment-confirmed", {setupIntent: setupIntent});
                break;
              }

              case "processing": {
                topbar.hide();
                messageContainer.innerText =
                  "Processing payment details. We'll update you when processing is complete.";
                buttonText.textContent = "Pay";
                break;
              }

              case "requires_payment_method": {
                topbar.hide();
                messageContainer.innerText =
                  "Failed to process payment details. Please try another payment method.";
                buttonText.textContent = "Pay";
                break;
              }
            }
          }
        )
      }
    });
  }
};
