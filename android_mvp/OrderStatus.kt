package com.ecommerce.checkout.model

/**
 * OrderStatus defines the secure, robust state machine of an order's lifecycle.
 * State Transitions should only occur in the following logical sequence:
 * PENDING -> PLACED -> PROCESSING -> SHIPPED -> DELIVERED
 * Any state can transition to CANCELLED before SHIPPING.
 * PLACED/PROCESSING/SHIPPED/DELIVERED can transition to REFUNDED.
 */
enum class OrderStatus {
    /**
     * Order has been initiated/created on the server side and is awaiting 
     * payment confirmation from the gateway. Stock is temporarily reserved.
     */
    PENDING,

    /**
     * Payment signature has been successfully verified by the backend.
     * The order is officially confirmed. Stock is deducted permanently.
     */
    PLACED,

    /**
     * The order is currently being processed, packed, or prepared at the warehouse.
     */
    PROCESSING,

    /**
     * The order has been handed over to the logistics/courier partner.
     * A tracking ID is generated.
     */
    SHIPPED,

    /**
     * The package has been successfully delivered to the customer's verified address.
     */
    DELIVERED,

    /**
     * The order was cancelled (either by the user before shipping or due to payment timeout/failure).
     * Any reserved stock is returned to inventory.
     */
    CANCELLED,

    /**
     * The payment was reversed, and funds have been returned to the customer's account.
     * Stock may be returned depending on return inspection.
     */
    REFUNDED;

    /**
     * Helper methods to govern valid state transitions.
     */
    fun canTransitionTo(nextState: OrderStatus): Boolean {
        return when (this) {
            PENDING -> nextState == PLACED || nextState == CANCELLED
            PLACED -> nextState == PROCESSING || nextState == CANCELLED || nextState == REFUNDED
            PROCESSING -> nextState == SHIPPED || nextState == CANCELLED || nextState == REFUNDED
            SHIPPED -> nextState == DELIVERED || nextState == REFUNDED
            DELIVERED -> nextState == REFUNDED
            CANCELLED -> false // Terminal state
            REFUNDED -> false  // Terminal state
        }
    }
}
