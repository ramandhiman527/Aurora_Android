import { isFirebaseConfigured, firestore } from './config';
import { 
  collection, 
  getDocs, 
  doc, 
  getDoc, 
  addDoc, 
  setDoc, 
  updateDoc, 
  deleteDoc,
  query,
  where,
  orderBy
} from 'firebase/firestore';

// ==========================================
// INITIAL MOCK DATA (Mirroring Mobile App)
// ==========================================

const initialCategories = [
  { id: 'cat1', name: 'Mobiles', imageUrl: 'https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=300&q=80' },
  { id: 'cat2', name: 'Shoes', imageUrl: 'https://images.unsplash.com/photo-1533867617858-e7b97e060509?auto=format&fit=crop&w=300&q=80' },
  { id: 'cat3', name: 'Accessories', imageUrl: 'https://images.unsplash.com/photo-1627124765135-56673fc4f99b?auto=format&fit=crop&w=300&q=80' }
];

const initialProducts = [
  {
    id: 'prod1',
    name: 'HMD Crest Max 5G',
    description: 'Premium glass back meets outstanding performance. Featuring a 50MP triple AI camera, gorgeous matte finish back glass, and a vivid 90Hz AMOLED display.',
    price: 14999.0,
    originalPrice: 16999.0,
    categoryId: 'cat1',
    imageUrls: ['https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80'],
    availableSizes: ['8GB + 256GB'],
    availableColors: ['Royal Purple', 'Matte Black', 'Emerald Green'],
    averageRating: 4.8,
    totalReviews: 48,
    isFeatured: true,
    isTrending: true,
    isNewArrival: true,
    isLimitedEdition: false,
    stockCount: 15,
    createdAt: new Date().toISOString()
  },
  {
    id: 'prod2',
    name: 'HMD Crest 5G',
    description: 'Crafted for clarity and speed. Featuring a stunning 50MP Selfie Camera, 50MP dual rear camera setup, and 6GB RAM.',
    price: 12999.0,
    originalPrice: 14499.0,
    categoryId: 'cat1',
    imageUrls: ['https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80'],
    availableSizes: ['6GB + 128GB'],
    availableColors: ['Lush Peach', 'Midnight Blue'],
    averageRating: 4.7,
    totalReviews: 24,
    isFeatured: true,
    isTrending: false,
    isNewArrival: true,
    isLimitedEdition: false,
    stockCount: 12,
    createdAt: new Date().toISOString()
  },
  {
    id: 'prod3',
    name: 'HMD Pulse Pro 4G',
    description: 'Sleek, repairable, and durable. nordic design with easy self-repairability, an epic 3-day battery life, and smooth octa-core performance.',
    price: 9999.0,
    originalPrice: 11999.0,
    categoryId: 'cat1',
    imageUrls: ['https://images.unsplash.com/photo-1565849906660-7ea469f66870?auto=format&fit=crop&w=800&q=80'],
    availableSizes: ['6GB + 128GB'],
    availableColors: ['Glacier Green', 'Black Coal'],
    averageRating: 4.5,
    totalReviews: 32,
    isFeatured: false,
    isTrending: true,
    isNewArrival: false,
    isLimitedEdition: false,
    stockCount: 20,
    createdAt: new Date().toISOString()
  },
  {
    id: 'prod6',
    name: 'Sreeleathers Oxford Formal',
    description: 'The hallmark of corporate elegance. Handcrafted from genuine top-grain leather, featuring memory foam cushioning.',
    price: 1499.0,
    originalPrice: 1999.0,
    categoryId: 'cat2',
    imageUrls: ['https://images.unsplash.com/photo-1533867617858-e7b97e060509?auto=format&fit=crop&w=800&q=80'],
    availableSizes: ['UK 7', 'UK 8', 'UK 9', 'UK 10'],
    availableColors: ['Classic Tan', 'Stealth Black'],
    averageRating: 4.6,
    totalReviews: 45,
    isFeatured: true,
    isTrending: true,
    isNewArrival: true,
    isLimitedEdition: false,
    stockCount: 15,
    createdAt: new Date().toISOString()
  },
  {
    id: 'prod10',
    name: 'Sreeleathers Bifold Wallet',
    description: 'Minimalist genuine leather bifold wallet. Detailed with 6 card slots, a secret cash partition, and quick-access ID window.',
    price: 399.0,
    originalPrice: 599.0,
    categoryId: 'cat3',
    imageUrls: ['https://images.unsplash.com/photo-1627124765135-56673fc4f99b?auto=format&fit=crop&w=800&q=80'],
    availableSizes: ['Standard'],
    availableColors: ['Chestnut Brown', 'Jet Black'],
    averageRating: 4.8,
    totalReviews: 88,
    isFeatured: true,
    isTrending: true,
    isNewArrival: true,
    isLimitedEdition: false,
    stockCount: 40,
    createdAt: new Date().toISOString()
  }
];

const initialCustomers = [
  { uid: 'cust1', fullName: 'Bhawana Chandel', phone: '+91 9876543210', email: 'bhawana@example.com', customerRank: 'silver', createdAt: '2026-05-01T10:00:00Z', walletCashback: 250.0, walletPoints: 1200.0 },
  { uid: 'cust2', fullName: 'Rahul Sharma', phone: '+91 9988776655', email: 'rahul@example.com', customerRank: 'gold', createdAt: '2026-05-10T12:30:00Z', walletCashback: 500.0, walletPoints: 2400.0 },
  { uid: 'cust3', fullName: 'Priya Patel', phone: '+91 9898989898', email: 'priya@example.com', customerRank: 'platinum', createdAt: '2026-05-15T09:15:00Z', walletCashback: 1200.0, walletPoints: 5000.0 },
  { uid: 'cust4', fullName: 'Amit Verma', phone: '+91 9123456789', email: 'amit@example.com', customerRank: 'bronze', createdAt: '2026-05-18T14:22:00Z', walletCashback: 0.0, walletPoints: 100.0 }
];

const initialOrders = [
  {
    id: 'IR-20412',
    userId: 'cust1',
    customerName: 'Bhawana Chandel',
    items: [
      {
        product: { id: 'prod6', name: 'Sreeleathers Oxford Formal', price: 1499.0, imageUrl: 'https://images.unsplash.com/photo-1533867617858-e7b97e060509?auto=format&fit=crop&w=800&q=80' },
        quantity: 2,
        selectedSize: 'UK 8',
        selectedColor: 'Classic Tan'
      }
    ],
    totalAmount: 2998.0,
    discountAmount: 0.0,
    walletDeduction: 0.0,
    paidAmount: 2998.0,
    deliveryAddress: {
      fullName: 'Bhawana Chandel',
      phone: '+91 9876543210',
      streetAddress: 'Flat 402, Royal Palms, Sector 56',
      city: 'Gurugram',
      state: 'Haryana',
      postalCode: '122011',
      country: 'India'
    },
    status: 'delivered', // preparing, packed, shipped, outForDelivery, delivered
    paymentMethod: 'UPI',
    trackingId: 'TRK-9831048-A',
    orderDate: '2026-05-18T15:30:00Z'
  },
  {
    id: 'IR-88214',
    userId: 'cust2',
    customerName: 'Rahul Sharma',
    items: [
      {
        product: { id: 'prod1', name: 'HMD Crest Max 5G', price: 14999.0, imageUrl: 'https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80' },
        quantity: 1,
        selectedSize: '8GB + 256GB',
        selectedColor: 'Royal Purple'
      }
    ],
    totalAmount: 14999.0,
    discountAmount: 1499.9,
    walletDeduction: 100.0,
    paidAmount: 13399.1,
    deliveryAddress: {
      fullName: 'Rahul Sharma',
      phone: '+91 9988776655',
      streetAddress: 'Sector 45, H.No 1204',
      city: 'Gurugram',
      state: 'Haryana',
      postalCode: '122003',
      country: 'India'
    },
    status: 'shipped',
    paymentMethod: 'CARD',
    trackingId: 'TRK-882104-B',
    orderDate: '2026-05-20T10:45:00Z'
  },
  {
    id: 'IR-45102',
    userId: 'cust3',
    customerName: 'Priya Patel',
    items: [
      {
        product: { id: 'prod10', name: 'Sreeleathers Bifold Wallet', price: 399.0, imageUrl: 'https://images.unsplash.com/photo-1627124765135-56673fc4f99b?auto=format&fit=crop&w=800&q=80' },
        quantity: 1,
        selectedSize: 'Standard',
        selectedColor: 'Jet Black'
      }
    ],
    totalAmount: 399.0,
    discountAmount: 0.0,
    walletDeduction: 50.0,
    paidAmount: 349.0,
    deliveryAddress: {
      fullName: 'Priya Patel',
      phone: '+91 9898989898',
      streetAddress: 'Navrang Apartments, Dwarka Sec 12',
      city: 'New Delhi',
      state: 'Delhi',
      postalCode: '110075',
      country: 'India'
    },
    status: 'preparing',
    paymentMethod: 'COD',
    trackingId: 'TRK-451009-C',
    orderDate: '2026-05-21T08:30:00Z'
  }
];

const initialPromoCodes = [
  { code: 'LUXE10', type: 'percentage', value: 10, description: '10% discount on all store items' },
  { code: 'FIRSTBUY', type: 'flat', value: 500, description: 'Rs 500 off on your first order' },
  { code: 'RAMAN50', type: 'flat', value: 50, description: 'Rs 50 free credit for referral' }
];

const initialWalletTransactions = [
  { id: 'tx1', userId: 'cust1', description: 'Cashback received for Order #IR-20412', amount: 150.0, timestamp: '2026-05-18T15:35:00Z', isCredit: true },
  { id: 'tx2', userId: 'cust1', description: 'Referral credit (Invited Rahul S.)', amount: 100.0, timestamp: '2026-05-14T08:12:00Z', isCredit: true },
  { id: 'tx3', userId: 'cust2', description: 'Signup reward points conversion', amount: 500.0, timestamp: '2026-05-10T12:35:00Z', isCredit: true },
  { id: 'tx4', userId: 'cust2', description: 'Wallet deduction for Order #IR-88214', amount: 100.0, timestamp: '2026-05-20T10:45:00Z', isCredit: false }
];

const initialPushCampaigns = [
  { id: 'cam1', title: 'Midnight Drop Alert', message: 'The limited edition Chukka Boots are back in stock. Shop now!', target: 'all', timestamp: '2026-05-19T23:59:00Z', clicks: 124 },
  { id: 'cam2', title: 'Exclusive Voucher for VIPs', message: 'Use code VIPGOLD to unlock flat 20% off your next checkout.', target: 'gold', timestamp: '2026-05-20T12:00:00Z', clicks: 88 }
];

// Helper to initialize local storage
function initLocalStorage() {
  if (!localStorage.getItem('aura_categories')) {
    localStorage.setItem('aura_categories', JSON.stringify(initialCategories));
  }
  if (!localStorage.getItem('aura_products')) {
    localStorage.setItem('aura_products', JSON.stringify(initialProducts));
  }
  if (!localStorage.getItem('aura_customers')) {
    localStorage.setItem('aura_customers', JSON.stringify(initialCustomers));
  }
  if (!localStorage.getItem('aura_orders')) {
    localStorage.setItem('aura_orders', JSON.stringify(initialOrders));
  }
  if (!localStorage.getItem('aura_promos')) {
    localStorage.setItem('aura_promos', JSON.stringify(initialPromoCodes));
  }
  if (!localStorage.getItem('aura_wallet_txs')) {
    localStorage.setItem('aura_wallet_txs', JSON.stringify(initialWalletTransactions));
  }
  if (!localStorage.getItem('aura_push_campaigns')) {
    localStorage.setItem('aura_push_campaigns', JSON.stringify(initialPushCampaigns));
  }
}

// Ensure mock storage exists if we are running in simulator mode
if (!isFirebaseConfigured) {
  initLocalStorage();
}

// ==========================================
// DB SERVICE METHODS
// ==========================================

export const dbService = {
  // --- CATEGORIES ---
  async getCategories() {
    if (isFirebaseConfigured) {
      const q = query(collection(firestore, 'categories'), orderBy('orderIndex', 'asc'));
      const querySnapshot = await getDocs(q);
      return querySnapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
    } else {
      initLocalStorage();
      return JSON.parse(localStorage.getItem('aura_categories'));
    }
  },

  // --- PRODUCTS ---
  async getProducts() {
    if (isFirebaseConfigured) {
      const querySnapshot = await getDocs(collection(firestore, 'products'));
      return querySnapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
    } else {
      initLocalStorage();
      return JSON.parse(localStorage.getItem('aura_products'));
    }
  },

  async addProduct(productData) {
    if (isFirebaseConfigured) {
      const docRef = await addDoc(collection(firestore, 'products'), {
        ...productData,
        createdAt: new Date().toISOString()
      });
      return { id: docRef.id, ...productData };
    } else {
      const products = JSON.parse(localStorage.getItem('aura_products'));
      const newProduct = {
        id: 'prod' + Date.now(),
        ...productData,
        createdAt: new Date().toISOString()
      };
      products.unshift(newProduct);
      localStorage.setItem('aura_products', JSON.stringify(products));
      return newProduct;
    }
  },

  async updateProduct(id, productData) {
    if (isFirebaseConfigured) {
      const docRef = doc(firestore, 'products', id);
      await updateDoc(docRef, productData);
      return { id, ...productData };
    } else {
      const products = JSON.parse(localStorage.getItem('aura_products'));
      const index = products.findIndex(p => p.id === id);
      if (index === -1) throw new Error('Product not found');
      products[index] = { ...products[index], ...productData };
      localStorage.setItem('aura_products', JSON.stringify(products));
      return products[index];
    }
  },

  async deleteProduct(id) {
    if (isFirebaseConfigured) {
      const docRef = doc(firestore, 'products', id);
      await deleteDoc(docRef);
      return id;
    } else {
      let products = JSON.parse(localStorage.getItem('aura_products'));
      products = products.filter(p => p.id !== id);
      localStorage.setItem('aura_products', JSON.stringify(products));
      return id;
    }
  },

  // --- ORDERS ---
  async getOrders() {
    if (isFirebaseConfigured) {
      const querySnapshot = await getDocs(collection(firestore, 'orders'));
      return querySnapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
    } else {
      initLocalStorage();
      return JSON.parse(localStorage.getItem('aura_orders'));
    }
  },

  async updateOrderStatus(orderId, status) {
    if (isFirebaseConfigured) {
      const docRef = doc(firestore, 'orders', orderId);
      await updateDoc(docRef, { status, updatedAt: new Date().toISOString() });
      
      // Simulate pushing FCM notification
      await this.triggerPushNotificationSimulation(orderId, status);
      return true;
    } else {
      const orders = JSON.parse(localStorage.getItem('aura_orders'));
      const index = orders.findIndex(o => o.id === orderId);
      if (index === -1) throw new Error('Order not found');
      orders[index].status = status;
      orders[index].updatedAt = new Date().toISOString();
      localStorage.setItem('aura_orders', JSON.stringify(orders));

      // Simulate pushing FCM notification locally
      await this.triggerPushNotificationSimulation(orderId, status);
      return orders[index];
    }
  },

  async updateOrderTracking(orderId, { trackingId, deliveryPartner, estimatedDelivery, status }) {
    if (isFirebaseConfigured) {
      const docRef = doc(firestore, 'orders', orderId);
      const updateData = { updatedAt: new Date().toISOString() };
      if (trackingId !== undefined) updateData.trackingId = trackingId;
      if (deliveryPartner !== undefined) updateData.deliveryPartner = deliveryPartner;
      if (estimatedDelivery !== undefined) updateData.estimatedDelivery = estimatedDelivery;
      if (status !== undefined) updateData.status = status;
      
      await updateDoc(docRef, updateData);
      
      if (status !== undefined) {
        await this.triggerPushNotificationSimulation(orderId, status);
      }
      return true;
    } else {
      const orders = JSON.parse(localStorage.getItem('aura_orders'));
      const index = orders.findIndex(o => o.id === orderId);
      if (index === -1) throw new Error('Order not found');
      
      if (trackingId !== undefined) orders[index].trackingId = trackingId;
      if (deliveryPartner !== undefined) orders[index].deliveryPartner = deliveryPartner;
      if (estimatedDelivery !== undefined) orders[index].estimatedDelivery = estimatedDelivery;
      if (status !== undefined) orders[index].status = status;
      
      orders[index].updatedAt = new Date().toISOString();
      localStorage.setItem('aura_orders', JSON.stringify(orders));
      
      if (status !== undefined) {
        await this.triggerPushNotificationSimulation(orderId, status);
      }
      return orders[index];
    }
  },

  async triggerPushNotificationSimulation(orderId, status) {
    const statusTitles = {
      preparing: "Order Packed & Preparing",
      packed: "Shipment Sealed",
      shipped: "Order Dispatched",
      outForDelivery: "Out for Delivery",
      delivered: "Delivered 🎉"
    };

    const statusMessages = {
      preparing: `Your order #${orderId} is being prepared by our fulfillment partners.`,
      packed: `Your premium shipment #${orderId} has been security verified and packed.`,
      shipped: `In transit! Your package #${orderId} left our main warehouse hub.`,
      outForDelivery: `Your order #${orderId} is out with our logistics concierge in your city!`,
      delivered: `Successfully handed over! We hope you love your new Aura apparel & gear.`
    };

    console.log(`📡 [Push FCM Simulation] Sending Alert: "${statusTitles[status]}" -> "${statusMessages[status]}"`);
    
    // Log the push notification sent to the local campaigns list
    const campaigns = JSON.parse(localStorage.getItem('aura_push_campaigns')) || [];
    campaigns.unshift({
      id: 'cam_' + Date.now(),
      title: statusTitles[status],
      message: statusMessages[status],
      target: `customer_order_${orderId}`,
      timestamp: new Date().toISOString(),
      clicks: 1 // default initial click
    });
    localStorage.setItem('aura_push_campaigns', JSON.stringify(campaigns));
  },

  // --- CUSTOMERS ---
  async getCustomers() {
    if (isFirebaseConfigured) {
      const querySnapshot = await getDocs(collection(firestore, 'users'));
      return querySnapshot.docs.map(doc => ({ uid: doc.id, ...doc.data() }));
    } else {
      initLocalStorage();
      return JSON.parse(localStorage.getItem('aura_customers'));
    }
  },

  async updateCustomerRank(uid, customerRank) {
    if (isFirebaseConfigured) {
      const docRef = doc(firestore, 'users', uid);
      await updateDoc(docRef, { customerRank });
      return true;
    } else {
      const customers = JSON.parse(localStorage.getItem('aura_customers'));
      const index = customers.findIndex(c => c.uid === uid);
      if (index === -1) throw new Error('Customer not found');
      customers[index].customerRank = customerRank;
      localStorage.setItem('aura_customers', JSON.stringify(customers));
      return customers[index];
    }
  },

  async adjustCustomerWallet(uid, amount, type = 'cashback', isCredit = true) {
    // Manually credit or debit customer wallets
    const description = isCredit 
      ? `Concierge Admin adjustment (${type === 'points' ? 'Points credited' : 'Cashback credited'})`
      : `Concierge Admin adjustment (${type === 'points' ? 'Points debited' : 'Cashback debited'})`;
    
    if (isFirebaseConfigured) {
      // In production Firestore, we update user fields & add a wallet transaction document
      const userRef = doc(firestore, 'users', uid);
      const userDoc = await getDoc(userRef);
      if (userDoc.exists()) {
        const userData = userDoc.data();
        let balance = type === 'points' 
          ? (userData.walletPoints || 0) 
          : (userData.walletCashback || 0);
          
        balance = isCredit ? balance + amount : Math.max(0, balance - amount);
        
        await updateDoc(userRef, {
          [type === 'points' ? 'walletPoints' : 'walletCashback']: balance
        });

        await addDoc(collection(firestore, 'wallet_transactions'), {
          userId: uid,
          description,
          amount,
          isCredit,
          timestamp: new Date().toISOString()
        });
      }
    } else {
      // Local storage implementation
      const customers = JSON.parse(localStorage.getItem('aura_customers'));
      const index = customers.findIndex(c => c.uid === uid);
      if (index === -1) throw new Error('Customer not found');

      if (type === 'points') {
        const currentPoints = customers[index].walletPoints || 0;
        customers[index].walletPoints = isCredit ? currentPoints + amount : Math.max(0, currentPoints - amount);
      } else {
        const currentCash = customers[index].walletCashback || 0;
        customers[index].walletCashback = isCredit ? currentCash + amount : Math.max(0, currentCash - amount);
      }

      localStorage.setItem('aura_customers', JSON.stringify(customers));

      // Log wallet transaction
      const txs = JSON.parse(localStorage.getItem('aura_wallet_txs'));
      txs.unshift({
        id: 'tx_' + Date.now(),
        userId: uid,
        description,
        amount,
        timestamp: new Date().toISOString(),
        isCredit
      });
      localStorage.setItem('aura_wallet_txs', JSON.stringify(txs));

      return customers[index];
    }
  },

  // --- WALLET TRANSACTIONS ---
  async getWalletTransactions() {
    if (isFirebaseConfigured) {
      const querySnapshot = await getDocs(collection(firestore, 'wallet_transactions'));
      return querySnapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
    } else {
      initLocalStorage();
      return JSON.parse(localStorage.getItem('aura_wallet_txs'));
    }
  },

  // --- PROMO CODES (COUPONS) ---
  async getPromoCodes() {
    if (isFirebaseConfigured) {
      const querySnapshot = await getDocs(collection(firestore, 'promos'));
      return querySnapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
    } else {
      initLocalStorage();
      return JSON.parse(localStorage.getItem('aura_promos'));
    }
  },

  async addPromoCode(promoData) {
    if (isFirebaseConfigured) {
      const docRef = await addDoc(collection(firestore, 'promos'), promoData);
      return { id: docRef.id, ...promoData };
    } else {
      const promos = JSON.parse(localStorage.getItem('aura_promos'));
      const newPromo = {
        id: 'promo_' + Date.now(),
        ...promoData
      };
      promos.unshift(newPromo);
      localStorage.setItem('aura_promos', JSON.stringify(promos));
      return newPromo;
    }
  },

  async deletePromoCode(id) {
    if (isFirebaseConfigured) {
      const docRef = doc(firestore, 'promos', id);
      await deleteDoc(docRef);
      return id;
    } else {
      let promos = JSON.parse(localStorage.getItem('aura_promos'));
      // Match by id or code
      promos = promos.filter(p => p.id !== id && p.code !== id);
      localStorage.setItem('aura_promos', JSON.stringify(promos));
      return id;
    }
  },

  // --- PUSH NOTIFICATION DISPATCHER ---
  async getPushCampaigns() {
    if (isFirebaseConfigured) {
      const querySnapshot = await getDocs(collection(firestore, 'push_campaigns'));
      return querySnapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
    } else {
      initLocalStorage();
      return JSON.parse(localStorage.getItem('aura_push_campaigns'));
    }
  },

  async sendBroadcastNotification(campaignData) {
    console.log(`🚀 [Broadcasting FCM Campaign] "${campaignData.title}" target audience: "${campaignData.target}"`);
    
    if (isFirebaseConfigured) {
      const docRef = await addDoc(collection(firestore, 'push_campaigns'), {
        ...campaignData,
        timestamp: new Date().toISOString(),
        clicks: 0
      });
      return { id: docRef.id, ...campaignData };
    } else {
      const campaigns = JSON.parse(localStorage.getItem('aura_push_campaigns'));
      const newCam = {
        id: 'cam_' + Date.now(),
        ...campaignData,
        timestamp: new Date().toISOString(),
        clicks: Math.floor(Math.random() * 15) // mock some initial organic clicks
      };
      campaigns.unshift(newCam);
      localStorage.setItem('aura_push_campaigns', JSON.stringify(campaigns));
      return newCam;
    }
  }
};
