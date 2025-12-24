// index.js
const functions = require("firebase-functions");
const stripe = require("stripe")("sk_test_51SXIihPNgXcEyktDS0k8mbEvwRq2b3TXaTFsfRIXPOzHuWhx5nmPSjRN1VnXnu32duulkp7arNTjDJBPypTCnF7l00h6Kzc6wP"); // Replace with your Stripe secret key
const cors = require("cors")({ origin: true });

// Create Payment Intent
exports.createPaymentIntent = functions.https.onRequest((req, res) => {
  cors(req, res, async () => {
    try {
      const { amount } = req.body;

      if (!amount || amount < 50) {
        return res.status(400).json({ error: "Amount must be at least 50 paise" });
      }

      // Create PaymentIntent
      const paymentIntent = await stripe.paymentIntents.create({
        amount: amount, // amount in paise
        currency: "inr",
        automatic_payment_methods: { enabled: true }, // enables UPI, cards, wallets
      });

      // Return client secret
      res.status(200).json({ clientSecret: paymentIntent.client_secret });
    } catch (error) {
      console.error("Error creating PaymentIntent:", error);
      res.status(500).json({ error: error.message });
    }
  });
});











// // server.js
// const functions = require("firebase-functions");
// const admin = require("firebase-admin");
// admin.initializeApp();
// const stripe = require("stripe")("sk_test_51SXIihPNgXcEyktDS0k8mbEvwRq2b3TXaTFsfRIXPOzHuWhx5nmPSjRN1VnXnu32duulkp7arNTjDJBPypTCnF7l00h6Kzc6wP");  // <--- Put Stripe Secret Key here

// exports.createPaymentIntent = functions.https.onRequest(async (req, res) => {
//   try {
//     const { amount } = req.body;

//     // Check amount
//     if (!amount || amount < 1000) {  // Minimum ₹10 = 1000 paise
//       return res.status(400).send({ error: "Amount must be at least ₹10" });
//     }

//     const paymentIntent = await stripe.paymentIntents.create({
//       amount: amount,      // In paise: ₹50 = 5000
//       currency: "inr",     // <<--- IMPORTANT!
//       automatic_payment_methods: { enabled: true }
//     });

//     res.send({
//       clientSecret: paymentIntent.client_secret,
//     });

//   } catch (error) {
//     res.status(500).send({ error: error.message });
//   }
// });










// const stripe = require('stripe')('sk_test_51SXIihPNgXcEyktDS0k8mbEvwRq2b3TXaTFsfRIXPOzHuWhx5nmPSjRN1VnXnu32duulkp7arNTjDJBPypTCnF7l00h6Kzc6wP');

// app.post('/create-payment-intent', async (req, res) => {
//   try {
//     const { amount, currency } = req.body;
    
//     const paymentIntent = await stripe.paymentIntents.create({
//       amount: amount, // in smallest currency unit (e.g., cents)
//       currency: currency || 'usd',
//       automatic_payment_methods: {
//         enabled: true,
//       },
//     });

//     res.send({
//       clientSecret: paymentIntent.client_secret,
//     });
//   } catch (error) {
//     console.error('Error creating payment intent:', error);
//     res.status(400).send({ error: error.message });
//   }
// });