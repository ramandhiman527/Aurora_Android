package com.ecommerce.checkout.presentation

import androidx.compose.animation.*
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.itemsIndexed
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Check
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material.icons.filled.Warning
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.PathEffect
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.ecommerce.checkout.model.OrderStatus

// Elegant Dark Color Palette
val SlateDark = Color(0xFF0D0E15)
val AccentIndigo = Color(0xFF6366F1)
val EmeraldGreen = Color(0xFF10B981)
val CoralRed = Color(0xFFEF4444)
val CharcoalGray = Color(0xFF1E293B)
val LightSlate = Color(0xFF94A3B8)

@OptIn(ExperimentalAnimationApi::class)
@Composable
fun CheckoutFlowScreen(
    viewModel: CheckoutViewModel,
    onInitiatePayment: (orderId: String, amountInPaisa: Long, email: String, contact: String) -> Unit,
    onNavigateBack: () -> Unit
) {
    val state by viewModel.uiState.collectAsState()

    AnimatedContent(
        targetState = state,
        transitionSpec = {
            fadeIn() + slideInVertically() with fadeOut() + slideOutVertically()
        },
        label = "CheckoutStateTransition"
    ) { targetState ->
        when (targetState) {
            is CheckoutUiState.Idle -> {
                CheckoutIdleScreen(
                    onPayClicked = {
                        // Mock Order generation payload from parent view:
                        // Generates a mock checkout of Rs. 2,999.00
                        onInitiatePayment(
                            "order_Lp9xZ2Jk8Yt1sQ", 
                            299900L, 
                            "customer@aura.com", 
                            "+919876543210"
                        )
                    },
                    onBack = onNavigateBack
                )
            }
            is CheckoutUiState.Loading -> {
                CheckoutLoadingScreen()
            }
            is CheckoutUiState.PaymentSuccess -> {
                OrderSuccessScreen(
                    orderId = targetState.orderId,
                    transactionId = targetState.transactionId,
                    timelineSteps = targetState.trackingTimeline,
                    onContinueShopping = {
                        viewModel.resetState()
                        onNavigateBack()
                    }
                )
            }
            is CheckoutUiState.PaymentError -> {
                PaymentFailedScreen(
                    errorMessage = targetState.errorMessage,
                    errorCode = targetState.errorCode,
                    onRetry = {
                        viewModel.resetState()
                    },
                    onCancel = {
                        viewModel.resetState()
                        onNavigateBack()
                    }
                )
            }
        }
    }
}

/**
 * Loading overlay with a modern pulsing indicator representing transaction verification.
 */
@Composable
fun CheckoutLoadingScreen() {
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(SlateDark),
        contentAlignment = Alignment.Center
    ) {
        Column(
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            CircularProgressIndicator(
                color = AccentIndigo,
                strokeWidth = 4.dp,
                modifier = Modifier.size(56.dp)
            )
            Spacer(modifier = Modifier.height(24.dp))
            Text(
                text = "Securing Your Order...",
                color = Color.White,
                fontSize = 18.sp,
                fontWeight = FontWeight.SemiBold,
                textAlign = TextAlign.Center
            )
            Spacer(modifier = Modifier.height(8.dp))
            Text(
                text = "Verifying cryptographic signatures securely on our servers.",
                color = LightSlate,
                fontSize = 14.sp,
                textAlign = TextAlign.Center,
                modifier = Modifier.padding(horizontal = 32.dp)
            )
        }
    }
}

/**
 * Entry screen modeling checkout activation triggers
 */
@Composable
fun CheckoutIdleScreen(
    onPayClicked: () -> Unit,
    onBack: () -> Unit
) {
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(SlateDark)
            .padding(24.dp)
    ) {
        Column(
            modifier = Modifier.align(Alignment.Center),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text(
                text = "Checkout Confirmation",
                color = Color.White,
                fontSize = 26.sp,
                fontWeight = FontWeight.Bold
            )
            Spacer(modifier = Modifier.height(8.dp))
            Text(
                text = "Secure Checkout powered by Razorpay",
                color = LightSlate,
                fontSize = 14.sp
            )
            Spacer(modifier = Modifier.height(48.dp))
            
            // Modern summary card
            Card(
                shape = RoundedCornerShape(16.dp),
                colors = CardDefaults.cardColors(containerColor = CharcoalGray),
                modifier = Modifier.fillMaxWidth()
            ) {
                Column(modifier = Modifier.padding(24.dp)) {
                    Text("Summary", color = Color.White, fontWeight = FontWeight.Bold, fontSize = 16.sp)
                    Spacer(modifier = Modifier.height(16.dp))
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween
                    ) {
                        Text("Aura Signature Jacket", color = LightSlate)
                        Text("₹ 2,999.00", color = Color.White, fontWeight = FontWeight.Bold)
                    }
                    Divider(color = SlateDark, modifier = Modifier.padding(vertical = 16.dp))
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween
                    ) {
                        Text("Total Amount", color = Color.White, fontWeight = FontWeight.Bold)
                        Text("₹ 2,999.00", color = AccentIndigo, fontWeight = FontWeight.Bold, fontSize = 18.sp)
                    }
                }
            }
            
            Spacer(modifier = Modifier.height(32.dp))
            
            Button(
                onClick = onPayClicked,
                colors = ButtonDefaults.buttonColors(containerColor = AccentIndigo),
                shape = RoundedCornerShape(12.dp),
                modifier = Modifier
                    .fillMaxWidth()
                    .height(56.dp)
            ) {
                Text("Proceed to Secure Payment", color = Color.White, fontSize = 16.sp, fontWeight = FontWeight.Bold)
            }
        }
    }
}

/**
 * Success Screen displaying Order ID, transaction details, and a dynamic tracking timeline.
 */
@Composable
fun OrderSuccessScreen(
    orderId: String,
    transactionId: String,
    timelineSteps: List<TimelineStep>,
    onContinueShopping: () -> Unit
) {
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(SlateDark)
    ) {
        LazyColumn(
            modifier = Modifier
                .fillMaxSize()
                .padding(horizontal = 24.dp),
            contentPadding = PaddingValues(top = 48.dp, bottom = 120.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            item {
                // Success Badge Animation Header
                Box(
                    modifier = Modifier
                        .size(80.dp)
                        .clip(CircleShape)
                        .background(EmeraldGreen.copy(alpha = 0.2f))
                        .border(2.dp, EmeraldGreen, CircleShape),
                    contentAlignment = Alignment.Center
                ) {
                    Icon(
                        imageVector = Icons.Default.Check,
                        contentDescription = "Success",
                        tint = EmeraldGreen,
                        modifier = Modifier.size(40.dp)
                    )
                }
                
                Spacer(modifier = Modifier.height(24.dp))
                
                Text(
                    text = "Payment Successful!",
                    color = Color.White,
                    fontSize = 24.sp,
                    fontWeight = FontWeight.Bold,
                    textAlign = TextAlign.Center
                )
                
                Spacer(modifier = Modifier.height(8.dp))
                
                Text(
                    text = "Your signature was verified securely.",
                    color = LightSlate,
                    fontSize = 14.sp,
                    textAlign = TextAlign.Center
                )

                Spacer(modifier = Modifier.height(32.dp))

                // Order metadata card
                Card(
                    shape = RoundedCornerShape(16.dp),
                    colors = CardDefaults.cardColors(containerColor = CharcoalGray),
                    modifier = Modifier.fillMaxWidth()
                ) {
                    Column(modifier = Modifier.padding(20.dp)) {
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.SpaceBetween
                        ) {
                            Text("Order ID", color = LightSlate, fontSize = 13.sp)
                            Text(orderId, color = Color.White, fontWeight = FontWeight.Bold, fontSize = 13.sp)
                        }
                        Spacer(modifier = Modifier.height(12.dp))
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.SpaceBetween
                        ) {
                            Text("Transaction ID", color = LightSlate, fontSize = 13.sp)
                            Text(transactionId, color = Color.White, fontSize = 13.sp)
                        }
                        Spacer(modifier = Modifier.height(12.dp))
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.SpaceBetween
                        ) {
                            Text("Delivery Estimate", color = LightSlate, fontSize = 13.sp)
                            Text("2-3 Business Days", color = EmeraldGreen, fontWeight = FontWeight.Bold, fontSize = 13.sp)
                        }
                    }
                }

                Spacer(modifier = Modifier.height(32.dp))

                Text(
                    text = "Delivery Tracking Timeline",
                    color = Color.White,
                    fontSize = 16.sp,
                    fontWeight = FontWeight.Bold,
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(bottom = 16.dp),
                    textAlign = TextAlign.Left
                )
            }

            // Interactive tracking stepper
            itemsIndexed(timelineSteps) { index, step ->
                TimelineNodeItem(
                    step = step,
                    isLast = index == timelineSteps.lastIndex
                )
            }
        }

        // Bottom CTA Section
        Box(
            modifier = Modifier
                .align(Alignment.BottomCenter)
                .fillMaxWidth()
                .background(
                    Brush.verticalGradient(
                        colors = listOf(Color.Transparent, SlateDark.copy(alpha = 0.95f), SlateDark)
                    )
                )
                .padding(24.dp)
        ) {
            Button(
                onClick = onContinueShopping,
                colors = ButtonDefaults.buttonColors(containerColor = AccentIndigo),
                shape = RoundedCornerShape(12.dp),
                modifier = Modifier
                    .fillMaxWidth()
                    .height(56.dp)
            ) {
                Text("Continue Shopping", color = Color.White, fontSize = 16.sp, fontWeight = FontWeight.Bold)
            }
        }
    }
}

/**
 * Screen displaying payment errors with diagnosis details and explicit retry action.
 */
@Composable
fun PaymentFailedScreen(
    errorMessage: String,
    errorCode: Int,
    onRetry: () -> Unit,
    onCancel: () -> Unit
) {
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(SlateDark)
            .padding(24.dp)
    ) {
        Column(
            modifier = Modifier.align(Alignment.Center),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Box(
                modifier = Modifier
                    .size(80.dp)
                    .clip(CircleShape)
                    .background(CoralRed.copy(alpha = 0.2f))
                    .border(2.dp, CoralRed, CircleShape),
                contentAlignment = Alignment.Center
            ) {
                Icon(
                    imageVector = Icons.Default.Close,
                    contentDescription = "Failure",
                    tint = CoralRed,
                    modifier = Modifier.size(48.dp)
                )
            }

            Spacer(modifier = Modifier.height(24.dp))

            Text(
                text = "Payment Failed",
                color = Color.White,
                fontSize = 24.sp,
                fontWeight = FontWeight.Bold,
                textAlign = TextAlign.Center
            )

            Spacer(modifier = Modifier.height(12.dp))

            Text(
                text = "Reason: $errorMessage",
                color = LightSlate,
                fontSize = 14.sp,
                textAlign = TextAlign.Center,
                modifier = Modifier.padding(horizontal = 16.dp)
            )
            
            Text(
                text = "Error Code: $errorCode",
                color = CoralRed.copy(alpha = 0.8f),
                fontSize = 12.sp,
                fontWeight = FontWeight.Medium,
                modifier = Modifier.padding(top = 4.dp)
            )

            Spacer(modifier = Modifier.height(32.dp))

            // Informational Box about safety
            Card(
                shape = RoundedCornerShape(12.dp),
                colors = CardDefaults.cardColors(containerColor = CharcoalGray.copy(alpha = 0.5f)),
                modifier = Modifier.fillMaxWidth()
            ) {
                Row(
                    modifier = Modifier.padding(16.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Icon(
                        imageVector = Icons.Default.Warning,
                        contentDescription = "Warning",
                        tint = AccentIndigo,
                        modifier = Modifier.size(24.dp)
                    )
                    Spacer(modifier = Modifier.width(12.dp))
                    Text(
                        text = "If funds were deducted from your bank, the refund will trigger automatically. You can safely retry or contact support.",
                        color = LightSlate,
                        fontSize = 12.sp,
                        lineHeight = 16.sp
                    )
                }
            }
            
            Spacer(modifier = Modifier.height(32.dp))

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(16.dp)
            ) {
                OutlinedButton(
                    onClick = onCancel,
                    shape = RoundedCornerShape(12.dp),
                    colors = ButtonDefaults.outlinedButtonColors(contentColor = Color.White),
                    modifier = Modifier
                        .weight(1f)
                        .height(56.dp)
                        .border(1.dp, LightSlate.copy(alpha = 0.5f), RoundedCornerShape(12.dp))
                ) {
                    Text("Go Back")
                }

                Button(
                    onClick = onRetry,
                    shape = RoundedCornerShape(12.dp),
                    colors = ButtonDefaults.buttonColors(containerColor = AccentIndigo),
                    modifier = Modifier
                        .weight(1f)
                        .height(56.dp)
                ) {
                    Icon(Icons.Default.Refresh, contentDescription = "Retry")
                    Spacer(modifier = Modifier.width(8.dp))
                    Text("Retry", fontWeight = FontWeight.Bold)
                }
            }
        }
    }
}

/**
 * Elegant stepper implementation visualizer for tracking timelines.
 */
@Composable
fun TimelineNodeItem(
    step: TimelineStep,
    isLast: Boolean
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 8.dp),
        verticalAlignment = Alignment.Top
    ) {
        Column(
            horizontalAlignment = Alignment.CenterHorizontally,
            modifier = Modifier.width(36.dp)
        ) {
            val nodeColor = when {
                step.isCurrent -> AccentIndigo
                step.isCompleted -> EmeraldGreen
                else -> CharcoalGray
            }
            
            // Outer Ring
            Box(
                modifier = Modifier
                    .size(24.dp)
                    .clip(CircleShape)
                    .background(nodeColor.copy(alpha = 0.2f))
                    .border(2.dp, nodeColor, CircleShape),
                contentAlignment = Alignment.Center
            ) {
                // Inner Dot
                Box(
                    modifier = Modifier
                        .size(8.dp)
                        .clip(CircleShape)
                        .background(nodeColor)
                )
            }
            
            if (!isLast) {
                val pathEffect = if (step.isCompleted) null else PathEffect.dashPathEffect(floatArrayOf(10f, 10f), 0f)
                val lineColor = if (step.isCompleted) EmeraldGreen else LightSlate.copy(alpha = 0.3f)
                
                Canvas(
                    modifier = Modifier
                        .height(50.dp)
                        .width(2.dp)
                ) {
                    drawLine(
                        color = lineColor,
                        start = Offset(0f, 0f),
                        end = Offset(0f, size.height),
                        strokeWidth = 4f,
                        pathEffect = pathEffect
                    )
                }
            }
        }
        
        Spacer(modifier = Modifier.width(16.dp))
        
        Column(
            modifier = Modifier
                .padding(bottom = 24.dp)
                .fillMaxWidth()
        ) {
            Text(
                text = step.title,
                color = if (step.isCurrent) Color.White else LightSlate,
                fontSize = 15.sp,
                fontWeight = if (step.isCurrent) FontWeight.Bold else FontWeight.SemiBold
            )
            Spacer(modifier = Modifier.height(4.dp))
            Text(
                text = step.description,
                color = if (step.isCurrent) LightSlate else LightSlate.copy(alpha = 0.6f),
                fontSize = 12.sp,
                lineHeight = 16.sp
            )
        }
    }
}
