package com.ecommerce.checkout.presentation

import android.os.Bundle
import android.util.Log
import android.widget.Toast
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.ui.Modifier
import com.ecommerce.checkout.data.CheckoutRepositoryImpl
import com.razorpay.Checkout
import com.razorpay.PaymentData
import com.razorpay.PaymentResultWithDataListener
import okhttp3.OkHttpClient
import org.json.JSONObject

class CheckoutActivity : ComponentActivity(), PaymentResultWithDataListener {

    private val tag = "CheckoutActivity"

    // Instantiate repository and viewmodel. 
    // In production, these should be injected using Hilt/Dagger DI framework.
    private val httpClient = OkHttpClient()
    private val repository = CheckoutRepositoryImpl(httpClient)
    private val viewModel = CheckoutViewModel(repository)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Preload Razorpay resources to improve loading speed on checkout launch
        Checkout.preload(applicationContext)

        setContent {
            MaterialTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    // Compose Checkout Handler and Flow Screen
                    CheckoutFlowScreen(
                        viewModel = viewModel,
                        onInitiatePayment = { orderId, amountInPaisa, email, contact ->
                            startPayment(
                                orderId = orderId,
                                amountInPaisa = amountInPaisa,
                                userEmail = email,
                                userContact = contact
                            )
                        },
                        onNavigateBack = {
                            finish()
                        }
                    )
                }
            }
        }
    }

    /**
     * Initializes and opens the Razorpay checkout overlay with modern custom branding options.
     *
     * @param orderId Server-generated order ID (necessary to bind the client checkout process to a secure server order)
     * @param amountInPaisa Transaction value in smallest currency denomination (e.g., INR 10.00 = 1000 paisa)
     * @param userEmail Pre-filled customer email for invoice routing
     * @param userContact Pre-filled customer phone number
     */
    private fun startPayment(
        orderId: String,
        amountInPaisa: Long,
        userEmail: String,
        userContact: String
    ) {
        val checkout = Checkout()
        // Replace with your actual merchant key from Razorpay dashboard (or fetch dynamically from server)
        checkout.setKeyID("rzp_test_MerchantKey123")

        // Set custom logo (optional, can pass drawable ID)
        // checkout.setImage(R.drawable.logo_premium_fashion)

        try {
            val options = JSONObject().apply {
                put("name", "Aura Premium Fashion")
                put("description", "Premium Apparel Order #$orderId")
                put("order_id", orderId) // Binds checkout directly to Razorpay's server-side order
                put("currency", "INR")
                put("amount", amountInPaisa)
                
                // Prefill user contact details to maximize payment conversions
                val prefill = JSONObject().apply {
                    put("email", userEmail)
                    put("contact", userContact)
                }
                put("prefill", prefill)

                // Modern visual aesthetic matching a premium dark-mode or clean glassmorphism UI theme
                val theme = JSONObject().apply {
                    put("color", "#0D0E15") // Deep Slate Midnight theme color
                    put("backdrop_color", "#1A1B23")
                }
                put("theme", theme)

                // Retries configuration
                val retry = JSONObject().apply {
                    put("enabled", true)
                    put("max_count", 3)
                }
                put("retry", retry)

                // Enable standard SMS/OTP automatic detection for frictionless mobile authentication
                put("send_sms_hash", true)
            }

            // Launch the checkout sheet overlay
            checkout.open(this, options)
            
            // Set UI state to Loading since checkout SDK is now active
            viewModel.setInitialLoading()

        } catch (e: Exception) {
            Log.e(tag, "Error initiating Razorpay checkout: ${e.message}", e)
            Toast.makeText(this, "Failed to start payment: ${e.localizedMessage}", Toast.LENGTH_LONG).show()
            viewModel.setPaymentFailed(
                errorCode = -3,
                description = "Checkout failed to initialize: ${e.localizedMessage}"
            )
        }
    }

    /**
     * Razorpay success callback.
     * Uses `PaymentResultWithDataListener` to capture the crucial cryptographic signatures
     * needed for backend validation.
     */
    override fun onPaymentSuccess(razorpayPaymentId: String?, paymentData: PaymentData?) {
        Log.d(tag, "Razorpay payment success: Payment ID = $razorpayPaymentId")
        
        if (paymentData != null && razorpayPaymentId != null) {
            val orderId = paymentData.orderId ?: ""
            val signature = paymentData.signature ?: ""

            if (orderId.isNotEmpty() && signature.isNotEmpty()) {
                // Forward credentials to backend for verification (prevents client spoofing)
                viewModel.verifyPaymentSignature(
                    paymentId = razorpayPaymentId,
                    signature = signature,
                    orderId = orderId
                )
            } else {
                Log.e(tag, "Signature or Order ID missing in success payload")
                viewModel.setPaymentFailed(
                    errorCode = -4,
                    description = "Payment verified locally but verification payload is malformed."
                )
            }
        } else {
            viewModel.setPaymentFailed(
                errorCode = -4,
                description = "Payment success returned null data."
            )
        }
    }

    /**
     * Razorpay failure callback.
     * Triggers when the user cancels payment, card validation fails, or payment is rejected by bank.
     */
    override fun onPaymentError(code: Int, response: String?, paymentData: PaymentData?) {
        Log.e(tag, "Razorpay payment error: Code = $code, Response = $response")
        
        val errorMessage = try {
            if (!response.isNullOrEmpty()) {
                val json = JSONObject(response)
                val error = json.optJSONObject("error")
                error?.optString("description") ?: "Payment canceled or rejected."
            } else {
                "Payment failed (Code $code)"
            }
        } catch (e: Exception) {
            response ?: "Payment canceled."
        }

        viewModel.setPaymentFailed(
            errorCode = code,
            description = errorMessage
        )
    }
}
