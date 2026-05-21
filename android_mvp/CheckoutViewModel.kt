package com.ecommerce.checkout.presentation

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.ecommerce.checkout.data.CheckoutRepository
import com.ecommerce.checkout.model.OrderStatus
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

/**
 * UI State representation for the Checkout and Payment verification loop.
 */
sealed interface CheckoutUiState {
    object Idle : CheckoutUiState
    object Loading : CheckoutUiState
    
    data class PaymentSuccess(
        val orderId: String,
        val transactionId: String,
        val trackingTimeline: List<TimelineStep>
    ) : CheckoutUiState

    data class PaymentError(
        val errorCode: Int,
        val errorMessage: String,
        val canRetry: Boolean = true
    ) : CheckoutUiState
}

/**
 * Represents a milestone step in the order tracking timeline for the UI success screen.
 */
data class TimelineStep(
    val status: OrderStatus,
    val title: String,
    val description: String,
    val isCompleted: Boolean,
    val isCurrent: Boolean
)

class CheckoutViewModel(
    private val checkoutRepository: CheckoutRepository
) : ViewModel() {

    private val _uiState = MutableStateFlow<CheckoutUiState>(CheckoutUiState.Idle)
    val uiState: StateFlow<CheckoutUiState> = _uiState.asStateFlow()

    // Hold current checkout info for retry operations
    private var lastAttemptedOrderId: String? = null
    private var lastAttemptedAmountInPaisa: Long = 0L

    fun setInitialLoading() {
        _uiState.value = CheckoutUiState.Loading
    }

    fun setPaymentFailed(errorCode: Int, description: String?) {
        _uiState.value = CheckoutUiState.PaymentError(
            errorCode = errorCode,
            errorMessage = description ?: "Payment cancelled or failed by bank."
        )
    }

    /**
     * Verifies the client payment signature on the backend and updates checkout UI state.
     */
    fun verifyPaymentSignature(paymentId: String, signature: String, orderId: String) {
        _uiState.value = CheckoutUiState.Loading
        viewModelScope.launch {
            checkoutRepository.verifyAndCreateOrder(
                paymentId = paymentId,
                signature = signature,
                orderId = orderId
            ).onSuccess { response ->
                if (response.success) {
                    val timeline = generateTrackingTimeline(response.finalStatus)
                    _uiState.value = CheckoutUiState.PaymentSuccess(
                        orderId = response.orderId,
                        transactionId = response.transactionId,
                        trackingTimeline = timeline
                    )
                } else {
                    _uiState.value = CheckoutUiState.PaymentError(
                        errorCode = -1,
                        errorMessage = response.message.ifEmpty { "Verification failed." }
                    )
                }
            }.onFailure { exception ->
                _uiState.value = CheckoutUiState.PaymentError(
                    errorCode = -2,
                    errorMessage = exception.localizedMessage ?: "Network verification error occurred. Please try again."
                )
            }
        }
    }

    fun resetState() {
        _uiState.value = CheckoutUiState.Idle
    }

    /**
     * Generates a structural tracking timeline based on current OrderStatus.
     */
    private fun generateTrackingTimeline(currentStatus: OrderStatus): List<TimelineStep> {
        val steps = listOf(
            Triple(OrderStatus.PENDING, "Order Initiated", "We have received your payment request"),
            Triple(OrderStatus.PLACED, "Payment Verified", "Order confirmed & reserved in inventory"),
            Triple(OrderStatus.PROCESSING, "Processing", "Your order is being picked and packed"),
            Triple(OrderStatus.SHIPPED, "Shipped", "Package handed to carrier partner"),
            Triple(OrderStatus.DELIVERED, "Delivered", "Package reached destination")
        )

        val currentOrdinal = currentStatus.ordinal
        return steps.map { (status, title, desc) ->
            val isCompleted = status.ordinal <= currentOrdinal && currentStatus != OrderStatus.CANCELLED
            val isCurrent = status == currentStatus
            TimelineStep(
                status = status,
                title = title,
                description = desc,
                isCompleted = isCompleted,
                isCurrent = isCurrent
            )
        }
    }
}
