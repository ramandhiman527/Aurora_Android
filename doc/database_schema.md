# Database Schema & API Integration Guidelines

This document provides schema definitions, database designs (focused on **Firebase Firestore**), API endpoint structures, and security considerations for the Aura Ecommerce application.

---

## 1. Firestore Database Schema

Firestore is a NoSQL document database. We model our database using collections, documents, and subcollections.

### `users` Collection
Tracks user profile data, loyalty rankings, and configurations.
- **Path**: `/users/{userId}`
- **Fields**:
  ```json
  {
    "uid": "string (matches Firebase Auth UID)",
    "fullName": "string",
    "phone": "string",
    "email": "string",
    "customerRank": "string [silver | gold | platinum]",
    "createdAt": "timestamp",
    "updatedAt": "timestamp",
    "fcmToken": "string (for push notifications)"
  }
  ```

#### `addresses` Subcollection
Keeps multiple delivery locations per user.
- **Path**: `/users/{userId}/addresses/{addressId}`
- **Fields**:
  ```json
  {
    "fullName": "string",
    "phone": "string",
    "streetAddress": "string",
    "city": "string",
    "state": "string",
    "postalCode": "string",
    "country": "string",
    "isDefault": "boolean",
    "createdAt": "timestamp"
  }
  ```

---

### `products` Collection
Maintains the inventory catalog.
- **Path**: `/products/{productId}`
- **Fields**:
  ```json
  {
    "name": "string",
    "description": "string",
    "price": "number (float)",
    "originalPrice": "number | null",
    "categoryId": "string (ref: categories.id)",
    "imageUrls": "array [string]",
    "availableSizes": "array [string]",
    "availableColors": "array [string]",
    "averageRating": "number (float)",
    "totalReviews": "number (integer)",
    "isFeatured": "boolean",
    "isTrending": "boolean",
    "isNewArrival": "boolean",
    "isLimitedEdition": "boolean",
    "stockCount": "number (integer)",
    "createdAt": "timestamp"
  }
  ```

#### `reviews` Subcollection
Holds buyer reviews for a specific product.
- **Path**: `/products/{productId}/reviews/{reviewId}`
- **Fields**:
  ```json
  {
    "userId": "string (ref: users.uid)",
    "username": "string",
    "rating": "number (float, 1.0 to 5.0)",
    "comment": "string",
    "createdAt": "timestamp"
  }
  ```

---

### `categories` Collection
Stores department tags (e.g. Sneakers, Outerwear).
- **Path**: `/categories/{categoryId}`
- **Fields**:
  ```json
  {
    "name": "string",
    "imageUrl": "string",
    "orderIndex": "number (integer, for positioning)"
  }
  ```

---

### `orders` Collection
Maintains purchase transactions and delivery status timelines.
- **Path**: `/orders/{orderId}`
- **Fields**:
  ```json
  {
    "userId": "string (ref: users.uid)",
    "items": "array of objects",
    "items.product": {
      "id": "string",
      "name": "string",
      "price": "number",
      "imageUrl": "string"
    },
    "items.quantity": "number",
    "items.selectedSize": "string",
    "items.selectedColor": "string",
    "totalAmount": "number",
    "discountAmount": "number",
    "walletDeduction": "number",
    "paidAmount": "number",
    "deliveryAddress": {
      "fullName": "string",
      "phone": "string",
      "streetAddress": "string",
      "city": "string",
      "state": "string",
      "postalCode": "string",
      "country": "string"
    },
    "status": "string [preparing | packed | shipped | outForDelivery | delivered]",
    "paymentMethod": "string [UPI | CARD | COD]",
    "razorpayPaymentId": "string | null",
    "trackingId": "string",
    "orderDate": "timestamp",
    "updatedAt": "timestamp"
  }
  ```

---

### `wallet_transactions` Collection
Maintains audit logs of customer cashbacks and referral spendings.
- **Path**: `/wallet_transactions/{transactionId}`
- **Fields**:
  ```json
  {
    "userId": "string (ref: users.uid)",
    "description": "string",
    "amount": "number",
    "timestamp": "timestamp",
    "isCredit": "boolean (true = earned, false = used)"
  }
  ```

---

## 2. API Endpoints Mapping

For server-based backends (e.g. Node.js with Express/TypeScript or Firebase Cloud Functions), implement the following REST routes:

### Authentication
- `POST /api/v1/auth/request-otp` - Validates phone format, triggers SMS gateway (Twilio/Firebase Auth SMS), caches temporary OTP.
- `POST /api/v1/auth/verify-otp` - Compares client code, issues JWT access token, creates user document in database if first-time signup.

### Checkout & Payment Gateways (Razorpay)
- `POST /api/v1/payment/create-order` - Requests an order ID from the Razorpay API using API keys securely on the backend. Returns a Razorpay order ID to the client.
- `POST /api/v1/payment/verify-signature` - Verifies Razorpay webhook signature hashes (`razorpay_payment_id`, `razorpay_order_id`, `razorpay_signature`) before confirming the order status in Firestore.

### Push Notifications
- `POST /api/v1/admin/orders/{orderId}/status` - Changes order status and fires a Firebase Cloud Messaging (FCM) message to the user's registered FCM token, triggering a native status-bar alert.

---

## 3. Firestore Security Rules

Deploy these rules to lock down resource read/writes based on caller authentication state:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // User Profiles: Users can read and update their own document
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      match /addresses/{addressId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
    
    // Catalog: Anyone can read, only Admin can write
    match /products/{productId} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.token.admin == true;
      
      match /reviews/{reviewId} {
        allow read: if true;
        allow create: if request.auth != null;
        allow delete: if request.auth != null && (request.auth.uid == resource.data.userId || request.auth.token.admin == true);
      }
    }

    match /categories/{categoryId} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.token.admin == true;
    }
    
    // Orders: Users can read/write their own orders. Admins can update all orders.
    match /orders/{orderId} {
      allow read: if request.auth != null && (resource.data.userId == request.auth.uid || request.auth.token.admin == true);
      allow create: if request.auth != null && request.resource.data.userId == request.auth.uid;
      allow update, delete: if request.auth != null && request.auth.token.admin == true;
    }

    // Wallet Logs: Users can only view their own transactions
    match /wallet_transactions/{txId} {
      allow read: if request.auth != null && resource.data.userId == request.auth.uid;
      allow write: if false; // Only cloud function backend can write transaction credits/debits
    }
  }
}
```
