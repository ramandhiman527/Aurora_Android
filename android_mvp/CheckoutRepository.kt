package com.ecommerce.checkout.data

import com.ecommerce.checkout.model.OrderStatus
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import okhttp3.MediaType.Companion.toMediaType
import org.json.JSONObject
import java.io.IOException

/**
 * Data class representing the backend's verification response.
 */
data class OrderConfirmationResponse(
    val success: Boolean,
    val orderId: String,
    val transactionId: String,
    val finalStatus: OrderStatus,
    val message: String
)

/**
 * Repository handling checkout and payment verification operations.
 */
interface CheckoutRepository {
    /**
     * Sends the Razorpay payment details to the backend server for signature verification and order creation.
     *
     * @param paymentId The unique payment ID returned by Razorpay (razorpay_payment_id)
     * @param signature The cryptographic signature returned by Razorpay (razorpay_signature)
     * @param orderId The server-generated Razorpay order ID (razorpay_order_id)
     * @return Result wrapping OrderConfirmationResponse
     */
    suspend fun verifyAndCreateOrder(
        paymentId: String,
        signature: String,
        orderId: String
    ): Result<OrderConfirmationResponse>
}

class CheckoutRepositoryImpl(
    private val httpClient: OkHttpClient,
    private val baseUrl: String = "https://api.premiumfashion.com/v1"
) : CheckoutRepository {

    private val jsonMediaType = "application/json; charset=utf-8".toMediaType()

    override suspend fun verifyAndCreateOrder(
        paymentId: String,
        signature: String,
        orderId: String
    ): Result<OrderConfirmationResponse> = withContext(Dispatchers.IO) {
        try {
            // Build the secure API request payload
            val requestBodyJson = JSONObject().apply {
                put("razorpay_payment_id", paymentId)
                put("razorpay_signature", signature)
                put("razorpay_order_id", orderId)
            }

            val request = Request.Builder()
                .url("$baseUrl/orders/verify-payment")
                .post(requestBodyJson.toString().toRequestBody(jsonMediaType))
                .addHeader("Content-Type", "application/json")
                .addHeader("X-Device-Type", "Android")
                // In production, add user auth tokens: .addHeader("Authorization", "Bearer $authToken")
                .build()

            httpClient.newCall(request).execute().use { response ->
                val responseBody = response.body?.string()
                
                if (!response.isSuccessful || responseBody == null) {
                    return@withContext Result.failure(
                        IOException("Server error: Code ${response.code} - ${response.message}")
                    )
                }

                val jsonResponse = JSONObject(responseBody)
                val isSuccess = jsonResponse.optBoolean("success", false)
                val statusString = jsonResponse.optString("status", "PENDING")
                val confirmedOrderId = jsonResponse.optString("order_id", orderId)
                val transactionId = jsonResponse.optString("transaction_id", paymentId)
                val message = jsonResponse.optString("message", "")

                if (isSuccess) {
                    Result.success(
                        OrderConfirmationResponse(
                            success = true,
                            orderId = confirmedOrderId,
                            transactionId = transactionId,
                            finalStatus = OrderStatus.valueOf(statusString),
                            message = message
                        )
                    )
                } else {
                    Result.failure(Exception(message.ifEmpty { "Verification failed on server" }))
                }
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
}

/*
 =====================================================================================
  SECURITY EXPLANATION: PREVENTING USER SPOOFING VIA BACKEND VERIFICATION & WEBHOOKS
 =====================================================================================
 1. WHY THE CLIENT CANNOT VALIDATE PAYMENTS:
    - If the client-side app directly updates the database to 'PLACED' after Razorpay calls
      `onPaymentSuccess`, a malicious actor could intercept network traffic or modify the client 
      binary to invoke the success callback directly without paying.
    - To prevent this, Razorpay provides a signature on payment completion:
      signature = HMAC-SHA256( razorpay_order_id + "|" + razorpay_payment_id, API_SECRET )
    - The API_SECRET must NEVER be included in the Android application package (APK) as it can
      be decompiled easily. Hence, signature verification must occur ONLY on a secure backend.

 2. SIGNATURE VERIFICATION WORKFLOW:
    - Client launches payment with a server-generated `razorpay_order_id`.
    - Client completes payment and receives `razorpay_payment_id` and `razorpay_signature`.
    - Client sends these values to the backend via `verifyAndCreateOrder`.
    - Backend generates its own HMAC-SHA256 signature using the secret key and compares it to 
      the `razorpay_signature` sent by the client.
    - If they match, the backend transitions the order status in the database from PENDING to PLACED.

 3. WEBHOOK AS THE ULTIMATE TRUTH (THE ASYNCHRONOUS CHECK):
    - Client-side connections are inherently unreliable. A user might close the app, lose cellular
      connectivity, or have their battery die at the exact moment the payment completes but before 
      `verifyAndCreateOrder` is successfully invoked.
    - If this happens, the user has paid, but the backend is still showing "PENDING".
    - To bridge this gap, Razorpay invokes an asynchronous server-to-server Webhook ("payment.authorized" 
      or "order.paid") immediately upon successful payment.
    - The backend listens to this Webhook, verifies the Webhook signature using a Webhook Secret, 
      and marks the order as "PLACED" in the database.
    - When the client app recovers or restarts, it fetches the order status from the backend. The backend 
      returns "PLACED" (synced by the Webhook), allowing the app to transition directly to the "Order Success" 
      screen and avoid double-charging or missing orders.
 =====================================================================================
 */
