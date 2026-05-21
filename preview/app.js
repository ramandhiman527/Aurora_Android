// Mock Data mirroring MockDatabase.dart
const categoriesData = [
  { id: 'cat1', name: 'Mobiles', imageUrl: 'https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=300&q=80' },
  { id: 'cat2', name: 'Shoes', imageUrl: 'https://images.unsplash.com/photo-1533867617858-e7b97e060509?auto=format&fit=crop&w=300&q=80' },
  { id: 'cat3', name: 'Accessories', imageUrl: 'https://images.unsplash.com/photo-1627124765135-56673fc4f99b?auto=format&fit=crop&w=300&q=80' }
];

let productsData = [
  {
    id: 'prod1',
    name: 'HMD Crest Max 5G',
    description: 'Premium glass back meets outstanding performance. Featuring a 50MP triple AI camera, gorgeous matte finish back glass, and a vivid 90Hz AMOLED display for premium visual clarity and modern elegance.',
    price: 14999.0,
    originalPrice: 16999.0,
    categoryId: 'cat1',
    imageUrls: ['https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80'],
    availableSizes: ['8GB + 256GB'],
    availableColors: ['Royal Purple', 'Matte Black', 'Emerald Green'],
    averageRating: 4.8,
    totalReviews: 48,
    reviews: [
      { username: 'Rohan P.', rating: 5, comment: 'Astonishing build quality. The purple glass look is extremely premium. Screen is buttery smooth.', date: '2026-05-19' },
      { username: 'Neha S.', rating: 4, comment: 'Decent battery backup. Performance is solid for everyday usage. 50MP camera does magic.', date: '2026-05-15' }
    ],
    isFeatured: true,
    isTrending: true,
    isNewArrival: true,
    stockCount: 15
  },
  {
    id: 'prod2',
    name: 'HMD Crest 5G',
    description: 'Crafted for clarity and speed. Featuring a stunning 50MP Selfie Camera, 50MP dual rear camera setup, and 6GB RAM + 128GB internal storage for seamless multitasking and daily gaming.',
    price: 12999.0,
    originalPrice: 14499.0,
    categoryId: 'cat1',
    imageUrls: ['https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80'],
    availableSizes: ['6GB + 128GB'],
    availableColors: ['Lush Peach', 'Midnight Blue'],
    averageRating: 4.7,
    totalReviews: 24,
    reviews: [
      { username: 'Vijay T.', rating: 4.5, comment: 'Awesome phone in this budget. Screen is nice.', date: '2026-05-18' }
    ],
    isFeatured: true,
    isTrending: false,
    isNewArrival: true,
    stockCount: 12
  },
  {
    id: 'prod3',
    name: 'HMD Pulse Pro 4G',
    description: 'Sleek, repairable, and durable. The Pulse Pro offers clean Nordic design with easy self-repairability, an epic 3-day battery life, and smooth octa-core performance for everyday efficiency.',
    price: 9999.0,
    originalPrice: 11999.0,
    categoryId: 'cat1',
    imageUrls: ['https://images.unsplash.com/photo-1565849906660-7ea469f66870?auto=format&fit=crop&w=800&q=80'],
    availableSizes: ['6GB + 128GB'],
    availableColors: ['Glacier Green', 'Black Coal'],
    averageRating: 4.5,
    totalReviews: 32,
    reviews: [
      { username: 'Aravind K.', rating: 4.5, comment: 'Great phone for parents. Simple interface, durable, and battery lasts forever!', date: '2026-05-18' }
    ],
    isFeatured: false,
    isTrending: true,
    isNewArrival: false,
    stockCount: 20
  },
  {
    id: 'prod4',
    name: 'HMD 105 Classic',
    description: 'Built to last. The HMD 105 classic keypad phone features built-in UPI payment support, a dual LED torch, wireless FM radio, and the legendary durable shell for seamless communications.',
    price: 1199.0,
    originalPrice: null,
    categoryId: 'cat1',
    imageUrls: ['https://images.unsplash.com/photo-1523206489230-c012c64b2b48?auto=format&fit=crop&w=800&q=80'],
    availableSizes: ['Standard'],
    availableColors: ['Charcoal Black', 'Ocean Blue'],
    averageRating: 4.3,
    totalReviews: 120,
    reviews: [
      { username: 'Rohan G.', rating: 5, comment: 'Perfect secondary phone. Built-in UPI payments is a major highlight.', date: '2026-05-20' }
    ],
    isFeatured: false,
    isTrending: true,
    isNewArrival: false,
    stockCount: 50
  },
  {
    id: 'prod5',
    name: 'HMD 110 Keypad',
    description: 'Simple yet feature-packed keypad phone. Features a built-in rear camera, UPI payment verification, MP3 music player support, and premium curved ergonomics.',
    price: 1699.0,
    originalPrice: 1999.0,
    categoryId: 'cat1',
    imageUrls: ['https://images.unsplash.com/photo-1573148195900-7845dcb9b127?auto=format&fit=crop&w=800&q=80'],
    availableSizes: ['Standard'],
    availableColors: ['Mint Green', 'Midnight Black'],
    averageRating: 4.4,
    totalReviews: 18,
    reviews: [
      { username: 'Preeti S.', rating: 4, comment: 'Very lightweight and reliable.', date: '2026-05-19' }
    ],
    isFeatured: false,
    isTrending: false,
    isNewArrival: true,
    stockCount: 25
  },
  {
    id: 'prod6',
    name: 'Sreeleathers Oxford Formal',
    description: 'The hallmark of corporate elegance. Handcrafted from genuine top-grain leather, featuring a sleek lace-up profile and memory foam cushioning for full-day office comfort.',
    price: 1499.0,
    originalPrice: 1999.0,
    categoryId: 'cat2',
    imageUrls: ['https://images.unsplash.com/photo-1533867617858-e7b97e060509?auto=format&fit=crop&w=800&q=80'],
    availableSizes: ['UK 7', 'UK 8', 'UK 9', 'UK 10'],
    availableColors: ['Classic Tan', 'Stealth Black'],
    averageRating: 4.6,
    totalReviews: 45,
    reviews: [
      { username: 'Amit K.', rating: 5, comment: 'Sreeleathers never fails in quality. Best genuine leather formal shoes at this price range!', date: '2026-05-18' }
    ],
    isFeatured: true,
    isTrending: true,
    isNewArrival: true,
    stockCount: 15
  },
  {
    id: 'prod7',
    name: 'Sreeleathers Leather Loafers',
    description: 'Effortless style for casual and semi-formal wear. Slip-on design with elasticated side panels and hand-stitched premium leather detailing.',
    price: 999.0,
    originalPrice: 1299.0,
    categoryId: 'cat2',
    imageUrls: ['https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?auto=format&fit=crop&w=800&q=80'],
    availableSizes: ['UK 7', 'UK 8', 'UK 9', 'UK 10'],
    availableColors: ['Rich Mahogany', 'Deep Navy'],
    averageRating: 4.5,
    totalReviews: 29,
    reviews: [
      { username: 'Sumit V.', rating: 4, comment: 'Highly comfortable loafers for daily wear.', date: '2026-05-17' }
    ],
    isFeatured: true,
    isTrending: true,
    isNewArrival: false,
    stockCount: 18
  },
  {
    id: 'prod8',
    name: 'Sreeleathers Chukka Boots',
    description: 'Rugged durability meets refined design. Ankle-high genuine suede leather chukka boots with slip-resistant TPR rubber outsoles and custom eyelets.',
    price: 2199.0,
    originalPrice: 2999.0,
    categoryId: 'cat2',
    imageUrls: ['https://images.unsplash.com/photo-1608256246200-53e635b5b65f?auto=format&fit=crop&w=800&q=80'],
    availableSizes: ['UK 8', 'UK 9', 'UK 10'],
    availableColors: ['Suede Tan', 'Carbon Black'],
    averageRating: 4.7,
    totalReviews: 38,
    reviews: [
      { username: 'Rajat P.', rating: 5, comment: 'These boots look premium and robust. Loving the suede feel.', date: '2026-05-19' }
    ],
    isFeatured: true,
    isTrending: false,
    isNewArrival: true,
    stockCount: 8
  },
  {
    id: 'prod9',
    name: 'Sreeleathers Breathable Sandals',
    description: 'Premium leather cross-strap sandals, featuring dual-density orthotic footbeds and adjustable brass buckle enclosures.',
    price: 899.0,
    originalPrice: 1099.0,
    categoryId: 'cat2',
    imageUrls: ['https://images.unsplash.com/photo-1603252109303-2751441dd157?auto=format&fit=crop&w=800&q=80'],
    availableSizes: ['UK 7', 'UK 8', 'UK 9'],
    availableColors: ['Espresso Brown', 'Soot Black'],
    averageRating: 4.3,
    totalReviews: 50,
    reviews: [
      { username: 'Lokesh T.', rating: 4, comment: 'Perfect for summers. Very soft sole.', date: '2026-05-15' }
    ],
    isFeatured: false,
    isTrending: true,
    isNewArrival: false,
    stockCount: 30
  },
  {
    id: 'prod10',
    name: 'Sreeleathers Bifold Wallet',
    description: 'Minimalist genuine leather bifold wallet. Detailed with 6 card slots, a secret cash partition, and a quick-access ID window.',
    price: 399.0,
    originalPrice: 599.0,
    categoryId: 'cat3',
    imageUrls: ['https://images.unsplash.com/photo-1627124765135-56673fc4f99b?auto=format&fit=crop&w=800&q=80'],
    availableSizes: ['Standard'],
    availableColors: ['Chestnut Brown', 'Jet Black'],
    averageRating: 4.8,
    totalReviews: 88,
    reviews: [
      { username: 'Aadesh H.', rating: 5, comment: 'Genuine leather at an unbelievable price. Highly recommend.', date: '2026-05-20' }
    ],
    isFeatured: true,
    isTrending: true,
    isNewArrival: true,
    stockCount: 40
  },
  {
    id: 'prod11',
    name: 'Sreeleathers Leather Belt',
    description: 'Formal full-grain leather belt with hand-painted burnished edges and a heavy-duty chrome buckle buckle.',
    price: 499.0,
    originalPrice: 699.0,
    categoryId: 'cat3',
    imageUrls: ['https://images.unsplash.com/photo-1553062407-98eeb64c6a62?auto=format&fit=crop&w=800&q=80'],
    availableSizes: ['32', '34', '36', '38'],
    availableColors: ['Cognac Brown', 'Onyx Black'],
    averageRating: 4.7,
    totalReviews: 122,
    reviews: [
      { username: 'Rohan N.', rating: 5, comment: 'Thick leather and very premium buckle. Fits perfectly.', date: '2026-05-19' }
    ],
    isFeatured: true,
    isTrending: false,
    isNewArrival: true,
    stockCount: 35
  },
  {
    id: 'prod12',
    name: 'Sreeleathers Messenger Bag',
    description: 'Premium genuine leather briefcase laptop messenger bag. Fitted with a padded 15.6-inch laptop pocket, metal zippers, and adjustable shoulder webbing.',
    price: 2499.0,
    originalPrice: 3499.0,
    categoryId: 'cat3',
    imageUrls: ['https://images.unsplash.com/photo-1590874103328-eac38a683ce7?auto=format&fit=crop&w=800&q=80'],
    availableSizes: ['Standard'],
    availableColors: ['Vintage Tan', 'Formal Black'],
    averageRating: 4.9,
    totalReviews: 54,
    reviews: [
      { username: 'Harsh R.', rating: 5, comment: 'Extremely spacious. Leather quality is top-notch.', date: '2026-05-20' }
    ],
    isFeatured: true,
    isTrending: true,
    isNewArrival: true,
    stockCount: 10
  },
  {
    id: 'prod13',
    name: 'Sreeleathers Key & Coin Pouch',
    description: 'A compact leather zip-around pouch designed to hold coins, house keys, and access cards. Includes a sturdy internal keyring clip.',
    price: 199.0,
    originalPrice: 299.0,
    categoryId: 'cat3',
    imageUrls: ['https://images.unsplash.com/photo-1584917865442-de89df76afd3?auto=format&fit=crop&w=800&q=80'],
    availableSizes: ['Standard'],
    availableColors: ['Wine Red', 'Forest Green', 'Tan'],
    averageRating: 4.2,
    totalReviews: 14,
    reviews: [
      { username: 'Preeti C.', rating: 4, comment: 'Very useful daily accessory.', date: '2026-05-16' }
    ],
    isFeatured: false,
    isTrending: false,
    isNewArrival: false,
    stockCount: 45
  }
];

// App State Variables
let isAuthenticated = false;
let walletCashback = 250.0;
let walletPoints = 1200.0;
let walletReferrals = 100.0;
let scratchUnlocked = false;
let promoCodes = { 'LUXE10': 0.10, 'FIRSTBUY': 500.0, 'RAMAN50': 50.0 };

let cart = [];
let wishlist = [];
let selectedAddressIndex = 0;
let selectedPaymentMethod = 'UPI';
let appliedPromo = null;
let useWallet = false;

const addresses = [
  { id: 'addr1', fullName: 'Bhawana Chandel', phone: '+91 98765 43210', streetAddress: 'Flat 402, Royal Palms, Sector 56', city: 'Gurugram', state: 'Haryana', postalCode: '122011', isDefault: true },
  { id: 'addr2', fullName: 'Bhawana Chandel (Office)', phone: '+91 98765 43210', streetAddress: 'Tower B, Global Tech Park, DLF Phase 3', city: 'Gurugram', state: 'Haryana', postalCode: '122002', isDefault: false }
];

let orders = [
  {
    id: 'IR-20412',
    items: [
      { product: productsData[5], quantity: 2, selectedSize: 'UK 8', selectedColor: 'Classic Tan', totalPrice: 2998.0 }
    ],
    totalAmount: 2998.0,
    discountAmount: 0.0,
    walletDeduction: 0.0,
    paidAmount: 2998.0,
    deliveryAddress: addresses[0],
    status: 'delivered', // preparing, packed, shipped, outForDelivery, delivered
    orderDate: '2026-05-18',
    paymentMethod: 'UPI',
    trackingId: 'TRK-9831048-A'
  }
];

let walletTransactions = [
  { description: 'Cashback received for Order #IR-20412', amount: 150.0, timestamp: '2026-05-18', isCredit: true },
  { description: 'Referral credit (Invited Rahul S.)', amount: 100.0, timestamp: '2026-05-14', isCredit: true }
];

// Active screens management
let currentActiveScreen = 'screen-login';
let currentActiveTab = 'home';
let selectedProduct = null;

// DOM Nodes references
const screenContainer = document.getElementById('screen-container');
const statusTime = document.getElementById('status-time');

// Update Clock time
function updateClock() {
  const now = new Date();
  let hours = now.getHours();
  let minutes = now.getMinutes();
  minutes = minutes < 10 ? '0' + minutes : minutes;
  hours = hours < 10 ? '0' + hours : hours;
  statusTime.innerText = `${hours}:${minutes}`;
}
setInterval(updateClock, 1000);
updateClock();

// Navigate Screens
function navigateTo(screenId) {
  document.querySelectorAll('.screen').forEach(scr => {
    scr.classList.remove('active');
  });
  const targetScreen = document.getElementById(screenId);
  targetScreen.classList.add('active');
  currentActiveScreen = screenId;
}

// Navigate Bottom Tabs Subscreens
function navigateToTab(tabId) {
  document.querySelectorAll('.sub-screen').forEach(sub => {
    sub.classList.remove('active');
  });
  document.querySelectorAll('.nav-item').forEach(item => {
    item.classList.remove('active');
  });

  const targetSub = document.getElementById(`subscreen-${tabId}`);
  targetSub.classList.add('active');
  
  const navItem = document.querySelector(`.nav-item[data-tab="${tabId}"]`);
  if (navItem) navItem.classList.add('active');
  
  currentActiveTab = tabId;

  // Render specific screens when opened
  if (tabId === 'home') {
    renderHome();
  } else if (tabId === 'discover') {
    renderDiscover();
  } else if (tabId === 'wallet') {
    renderWallet();
  } else if (tabId === 'profile') {
    renderProfile();
  }
}

// Render dynamic elements
function initApp() {
  lucide.createIcons();
  
  // Theme bindings
  document.getElementById('btn-light-theme').addEventListener('click', () => {
    document.body.classList.remove('dark-mode');
    document.body.classList.add('light-mode');
    document.getElementById('btn-light-theme').classList.add('active');
    document.getElementById('btn-dark-theme').classList.remove('active');
    document.getElementById('settings-darkmode-toggle').checked = false;
  });
  
  document.getElementById('btn-dark-theme').addEventListener('click', () => {
    document.body.classList.remove('light-mode');
    document.body.classList.add('dark-mode');
    document.getElementById('btn-dark-theme').classList.add('active');
    document.getElementById('btn-light-theme').classList.remove('active');
    document.getElementById('settings-darkmode-toggle').checked = true;
  });

  // Settings dark mode switch
  document.getElementById('settings-darkmode-toggle').addEventListener('change', (e) => {
    if (e.target.checked) {
      document.body.classList.add('dark-mode');
      document.body.classList.remove('light-mode');
      document.getElementById('btn-dark-theme').classList.add('active');
      document.getElementById('btn-light-theme').classList.remove('active');
    } else {
      document.body.classList.remove('dark-mode');
      document.body.classList.add('light-mode');
      document.getElementById('btn-light-theme').classList.add('active');
      document.getElementById('btn-dark-theme').classList.remove('active');
    }
  });

  // Auth Binds
  document.getElementById('btn-send-otp').addEventListener('click', () => {
    const phoneVal = document.getElementById('login-phone').value;
    if (phoneVal.length < 10) {
      alert('Please enter a valid 10-digit mobile number.');
      return;
    }
    document.getElementById('otp-phone-text').innerText = `We sent a 4-digit code to +91 ${phoneVal}`;
    navigateTo('screen-otp');
  });

  document.querySelectorAll('.back-to-login').forEach(btn => {
    btn.addEventListener('click', () => navigateTo('screen-login'));
  });

  document.getElementById('btn-verify-otp').addEventListener('click', () => {
    const code = 
      document.getElementById('otp-1').value + 
      document.getElementById('otp-2').value + 
      document.getElementById('otp-3').value + 
      document.getElementById('otp-4').value;
    
    if (code === '1234' || code.length === 4) {
      isAuthenticated = true;
      navigateTo('screen-main');
      navigateToTab('home');
    } else {
      alert('Invalid verification code! Try 1234.');
    }
  });

  // Bottom Nav Binds
  document.querySelectorAll('.nav-item').forEach(item => {
    item.addEventListener('click', (e) => {
      const tab = e.currentTarget.getAttribute('data-tab');
      navigateToTab(tab);
    });
  });

  // Go to Cart clicks
  document.querySelectorAll('.go-to-cart-trigger').forEach(btn => {
    btn.addEventListener('click', () => {
      navigateTo('screen-cart');
      renderCart();
    });
  });

  // Cart Back
  document.getElementById('btn-cart-back').addEventListener('click', () => {
    navigateTo('screen-main');
  });

  // Detail Back
  document.getElementById('btn-detail-back').addEventListener('click', () => {
    navigateTo('screen-main');
  });

  // Checkout Back
  document.getElementById('btn-checkout-back').addEventListener('click', () => {
    navigateTo('screen-cart');
  });

  // Tracking Back
  document.getElementById('btn-tracking-back').addEventListener('click', () => {
    navigateTo('screen-main');
    navigateToTab('profile');
  });

  // Settings screen navigation
  document.getElementById('btn-go-to-settings').addEventListener('click', () => {
    navigateTo('screen-settings');
  });

  document.getElementById('btn-settings-back').addEventListener('click', () => {
    navigateTo('screen-main');
    navigateToTab('profile');
  });

  document.getElementById('btn-settings-lang').addEventListener('click', () => {
    const lang = prompt('Select App Language:', 'English');
    if (lang) {
      document.getElementById('settings-lang-val').innerText = lang;
    }
  });

  // Log out button
  document.getElementById('btn-logout').addEventListener('click', () => {
    isAuthenticated = false;
    cart = [];
    appliedPromo = null;
    useWallet = false;
    updateCartBadges();
    navigateTo('screen-login');
  });

  // Search input actions
  document.getElementById('search-input').addEventListener('input', (e) => {
    const query = e.target.value.toLowerCase().trim();
    const resultsSection = document.getElementById('search-results-section');
    const defaultSection = document.getElementById('discover-default-section');
    
    if (query.length > 0) {
      resultsSection.style.display = 'block';
      defaultSection.style.display = 'none';
      
      const filtered = productsData.filter(p => 
        p.name.toLowerCase().includes(query) || 
        p.description.toLowerCase().includes(query)
      );
      
      document.getElementById('search-results-title').innerText = `Search Results (${filtered.length})`;
      const grid = document.getElementById('search-results-grid');
      grid.innerHTML = '';
      
      if (filtered.length === 0) {
        grid.innerHTML = `<p style="grid-column: 1 / span 2; text-align: center; padding: 24px 0; font-size: 13px; color: var(--text-muted);">No products match your query.</p>`;
      } else {
        filtered.forEach(p => {
          grid.appendChild(createProductCard(p));
        });
      }
    } else {
      resultsSection.style.display = 'none';
      defaultSection.style.display = 'block';
    }
    lucide.createIcons();
  });

  // Shortcut triggers
  document.getElementById('btn-shortcut-scratch').addEventListener('click', () => {
    if (!isAuthenticated) {
      alert('Please login first! Use digit verification code: 1234');
      return;
    }
    navigateTo('screen-main');
    navigateToTab('wallet');
    document.getElementById('btn-open-scratch-overlay').click();
  });

  document.getElementById('btn-shortcut-admin').addEventListener('click', () => {
    navigateTo('screen-admin');
    renderAdminDashboard();
  });

  document.getElementById('btn-home-admin').addEventListener('click', () => {
    navigateTo('screen-admin');
    renderAdminDashboard();
  });

  document.getElementById('btn-admin-back').addEventListener('click', () => {
    navigateTo('screen-main');
    navigateToTab('home');
  });

  document.getElementById('btn-shortcut-reset').addEventListener('click', () => {
    cart = [];
    appliedPromo = null;
    useWallet = false;
    scratchUnlocked = false;
    walletCashback = 250.0;
    document.getElementById('scratch-layer').classList.remove('scratched');
    updateCartBadges();
    if (currentActiveScreen === 'screen-cart') renderCart();
    alert('Mock state successfully reset.');
  });

  // Filter drawer trigger
  document.getElementById('btn-filter-drawer').addEventListener('click', () => {
    document.getElementById('filter-drawer').classList.add('active');
    renderFilterCategories();
  });

  document.getElementById('btn-close-filters').addEventListener('click', () => {
    document.getElementById('filter-drawer').classList.remove('active');
  });

  // Apply filters button
  let activeFilterSort = 'rating';
  let activeFilterCategory = null;
  let activeFilterSize = null;

  document.getElementById('btn-apply-filters').addEventListener('click', () => {
    document.getElementById('filter-drawer').classList.remove('active');
    applyDiscoverFilters();
  });

  document.getElementById('btn-clear-filters').addEventListener('click', () => {
    activeFilterSort = 'rating';
    activeFilterCategory = null;
    activeFilterSize = null;
    
    document.querySelectorAll('.sort-pill').forEach(p => p.classList.remove('active'));
    document.querySelector('.sort-pill[data-sort="rating"]').classList.add('active');
    
    document.querySelectorAll('.cat-filter-pill').forEach(p => p.classList.remove('active'));
    document.querySelectorAll('.size-pill').forEach(p => p.classList.remove('active'));
    
    document.getElementById('filter-drawer').classList.remove('active');
    applyDiscoverFilters();
  });

  // Sort pill selection inside drawer
  document.querySelectorAll('.sort-pill').forEach(pill => {
    pill.addEventListener('click', (e) => {
      document.querySelectorAll('.sort-pill').forEach(p => p.classList.remove('active'));
      e.target.classList.add('active');
      activeFilterSort = e.target.getAttribute('data-sort');
    });
  });

  // Size pill selection inside drawer
  document.querySelectorAll('.size-pill').forEach(pill => {
    pill.addEventListener('click', (e) => {
      if (e.target.classList.contains('active')) {
        e.target.classList.remove('active');
        activeFilterSize = null;
      } else {
        document.querySelectorAll('.size-pill').forEach(p => p.classList.remove('active'));
        e.target.classList.add('active');
        activeFilterSize = e.target.getAttribute('data-size');
      }
    });
  });

  // OTP inputs auto focus shifting
  document.querySelectorAll('.otp-box').forEach((box, idx) => {
    box.addEventListener('input', (e) => {
      if (e.target.value.length === 1 && idx < 3) {
        document.getElementById(`otp-${idx + 2}`).focus();
      }
    });
  });

  // Detail screen buttons
  document.getElementById('btn-detail-add-to-cart').addEventListener('click', () => {
    if (!selectedProduct) return;
    const selectedSize = document.querySelector('#detail-sizes-wrap .pill.active')?.innerText;
    const selectedColor = document.querySelector('#detail-colors-wrap .pill.active')?.innerText;
    
    addToCart(selectedProduct, selectedSize, selectedColor);
  });

  document.getElementById('btn-detail-buy-now').addEventListener('click', () => {
    if (!selectedProduct) return;
    const selectedSize = document.querySelector('#detail-sizes-wrap .pill.active')?.innerText;
    const selectedColor = document.querySelector('#detail-colors-wrap .pill.active')?.innerText;
    
    addToCart(selectedProduct, selectedSize, selectedColor);
    navigateTo('screen-cart');
    renderCart();
  });

  document.getElementById('btn-detail-wishlist').addEventListener('click', (e) => {
    if (!selectedProduct) return;
    toggleWishlist(selectedProduct, e.currentTarget);
  });

  // Cart actions
  document.getElementById('btn-cart-checkout').addEventListener('click', () => {
    navigateTo('screen-checkout');
    renderCheckout();
  });

  // Place order checkout button
  document.getElementById('btn-place-order').addEventListener('click', () => {
    if (selectedPaymentMethod === 'CARD') {
      // Trigger simulated Razorpay overlay
      const overlay = document.getElementById('overlay-razorpay');
      document.getElementById('rp-payable-amount').innerText = `₹${calculateFinalTotal().toFixed(2)}`;
      overlay.classList.add('active');
      
      // Simulate loading spinner
      document.getElementById('btn-rp-success').style.display = 'none';
      setTimeout(() => {
        document.getElementById('btn-rp-success').style.display = 'block';
        document.querySelector('.rp-loading-text').innerText = 'Authorized authorization key ready:';
      }, 1500);
    } else {
      finalizeOrderPlacement();
    }
  });

  // Razorpay triggers
  document.getElementById('btn-rp-cancel').addEventListener('click', () => {
    document.getElementById('overlay-razorpay').classList.remove('active');
    alert('Payment transaction aborted.');
  });

  document.getElementById('btn-rp-success').addEventListener('click', () => {
    document.getElementById('overlay-razorpay').classList.remove('active');
    finalizeOrderPlacement();
  });

  // Scratch card action logic
  document.getElementById('btn-open-scratch-overlay').addEventListener('click', () => {
    document.getElementById('overlay-scratch').classList.add('active');
  });

  document.getElementById('btn-close-scratch').addEventListener('click', () => {
    document.getElementById('overlay-scratch').classList.remove('active');
  });

  // Click on gray canvas scratches it
  document.getElementById('scratch-layer').addEventListener('click', () => {
    if (scratchUnlocked) return;
    scratchUnlocked = true;
    document.getElementById('scratch-layer').classList.add('scratched');
    
    // Add prize to balance
    walletCashback += 75.0;
    walletTransactions.unshift({
      description: 'Scratch Card Mystery Rewards',
      amount: 75.0,
      timestamp: '2026-05-21',
      isCredit: true
    });
    
    // Update Wallet tab balance live
    renderWallet();
  });

  // Load home data
  renderHome();
}

function updateCartBadges() {
  let count = 0;
  cart.forEach(item => count += item.quantity);
  document.querySelectorAll('.cart-badge').forEach(badge => {
    badge.innerText = count;
    badge.style.display = count > 0 ? 'flex' : 'none';
  });
}

function toggleWishlist(product, element) {
  const index = wishlist.findIndex(p => p.id === product.id);
  if (index >= 0) {
    wishlist.splice(index, 1);
    element.querySelector('i').style.fill = 'none';
    element.querySelector('i').style.color = 'var(--text-primary)';
  } else {
    wishlist.push(product);
    element.querySelector('i').style.fill = 'red';
    element.querySelector('i').style.color = 'red';
  }
}

function addToCart(product, size, color) {
  if (!size || !color) {
    alert('Please select size and color configurations first.');
    return;
  }
  
  const existingIndex = cart.findIndex(item => 
    item.product.id === product.id && 
    item.selectedSize === size && 
    item.selectedColor === color
  );

  if (existingIndex >= 0) {
    cart[existingIndex].quantity += 1;
    cart[existingIndex].totalPrice = cart[existingIndex].quantity * product.price;
  } else {
    cart.push({
      id: 'ci_' + Date.now(),
      product: product,
      quantity: 1,
      selectedSize: size,
      selectedColor: color,
      totalPrice: product.price
    });
  }
  
  updateCartBadges();
  alert(`${product.name} (Size: ${size}) added to your bag.`);
}

// Order Finalization
function finalizeOrderPlacement() {
  const finalTotal = calculateFinalTotal();
  const subtotal = calculateSubtotal();
  const discount = calculateDiscount();
  const walletUsed = useWallet ? Math.min(walletCashback, subtotal - discount) : 0;
  
  const newOrder = {
    id: 'IR-' + Math.floor(10000 + Math.random() * 90000),
    items: [...cart],
    totalAmount: subtotal,
    discountAmount: discount,
    walletDeduction: walletUsed,
    paidAmount: finalTotal,
    deliveryAddress: addresses[selectedAddressIndex],
    status: 'preparing',
    orderDate: '2026-05-21',
    paymentMethod: selectedPaymentMethod,
    trackingId: 'TRK-' + Math.floor(1000000 + Math.random() * 9000000) + '-A'
  };

  orders.unshift(newOrder);
  
  // Deduct wallet balance if chosen
  if (useWallet) {
    walletCashback -= walletUsed;
    walletTransactions.unshift({
      description: `Wallet debit for Order #${newOrder.id}`,
      amount: walletUsed,
      timestamp: '2026-05-21',
      isCredit: false
    });
  }

  // Clear cart
  cart = [];
  appliedPromo = null;
  useWallet = false;
  updateCartBadges();

  // Show Success Overlay
  navigateToOrderSuccess(newOrder);
}

function navigateToOrderSuccess(order) {
  document.getElementById('success-order-id').innerText = order.id;
  document.getElementById('success-payment-method').innerText = order.paymentMethod;
  document.getElementById('success-delivery-city').innerText = order.deliveryAddress.city;
  
  const successOverlay = document.getElementById('overlay-order-success');
  successOverlay.classList.add('active');

  // Track order button
  document.getElementById('btn-success-track').onclick = () => {
    successOverlay.classList.remove('active');
    navigateTo('screen-order-tracking');
    renderOrderTracking(order.id);
  };

  // Continue shopping button
  document.getElementById('btn-success-continue').onclick = () => {
    successOverlay.classList.remove('active');
    navigateTo('screen-main');
    navigateToTab('home');
  };
}

// Render: Home page
function renderHome() {
  // Categories
  const catWrap = document.getElementById('categories-list');
  catWrap.innerHTML = '';
  categoriesData.forEach(cat => {
    const div = document.createElement('div');
    div.className = 'cat-item-card';
    div.innerHTML = `
      <div class="cat-image-circle">
        <img src="${cat.imageUrl}" alt="${cat.name}">
      </div>
      <span>${cat.name}</span>
    `;
    div.onclick = () => {
      navigateToTab('discover');
      activeFilterCategory = cat.id;
      applyDiscoverFilters();
    };
    catWrap.appendChild(div);
  });

  // Featured
  const grid = document.getElementById('featured-products');
  grid.innerHTML = '';
  const featured = productsData.filter(p => p.isFeatured);
  featured.forEach(p => {
    grid.appendChild(createProductCard(p));
  });
  
  lucide.createIcons();
}

function createProductCard(p) {
  const item = document.createElement('div');
  item.className = 'product-item';
  item.onclick = (e) => {
    if (e.target.closest('.wishlist-heart-btn')) return;
    openProductDetails(p);
  };

  const isLiked = wishlist.some(item => item.id === p.id);
  const discountBadge = p.originalPrice ? `<span class="price-before">₹${p.originalPrice.toFixed(0)}</span>` : '';

  item.innerHTML = `
    <div class="product-img-wrap">
      <img src="${p.imageUrls[0]}" alt="${p.name}">
      <button class="wishlist-heart-btn ${isLiked ? 'liked' : ''}">
        <i data-lucide="heart"></i>
      </button>
    </div>
    <div class="product-info">
      <h3>${p.name}</h3>
      <div class="price-row">
        <span class="price-now">₹${p.price.toFixed(0)}</span>
        ${discountBadge}
      </div>
    </div>
  `;

  item.querySelector('.wishlist-heart-btn').onclick = (e) => {
    toggleWishlist(p, e.currentTarget);
  };

  return item;
}

// Open Product Details page
function openProductDetails(product) {
  selectedProduct = product;
  navigateTo('screen-product-detail');
  
  document.getElementById('detail-product-img').src = product.imageUrls[0];
  document.getElementById('detail-product-name').innerText = product.name;
  
  const categoryName = categoriesData.find(c => c.id === product.categoryId)?.name || 'DEPARTMENT';
  document.getElementById('detail-product-category').innerText = categoryName;
  
  document.getElementById('detail-product-price').innerText = `₹${product.price.toFixed(0)}`;
  const beforePrice = document.getElementById('detail-product-original-price');
  if (product.originalPrice) {
    beforePrice.style.display = 'inline';
    beforePrice.innerText = `₹${product.originalPrice.toFixed(0)}`;
  } else {
    beforePrice.style.display = 'none';
  }

  document.getElementById('detail-product-desc').innerText = product.description;

  // Render sizes
  const sizesWrap = document.getElementById('detail-sizes-wrap');
  sizesWrap.innerHTML = '';
  product.availableSizes.forEach((sz, idx) => {
    const pill = document.createElement('span');
    pill.className = `pill ${idx === 0 ? 'active' : ''}`;
    pill.innerText = sz;
    pill.onclick = () => {
      sizesWrap.querySelectorAll('.pill').forEach(p => p.classList.remove('active'));
      pill.classList.add('active');
    };
    sizesWrap.appendChild(pill);
  });

  // Render colors
  const colorsWrap = document.getElementById('detail-colors-wrap');
  colorsWrap.innerHTML = '';
  product.availableColors.forEach((col, idx) => {
    const pill = document.createElement('span');
    pill.className = `pill ${idx === 0 ? 'active' : ''}`;
    pill.innerText = col;
    pill.onclick = () => {
      colorsWrap.querySelectorAll('.pill').forEach(p => p.classList.remove('active'));
      pill.classList.add('active');
    };
    colorsWrap.appendChild(pill);
  });

  // Heart state
  const isLiked = wishlist.some(item => item.id === product.id);
  const heartBtn = document.getElementById('btn-detail-wishlist');
  if (isLiked) {
    heartBtn.querySelector('i').style.fill = 'red';
    heartBtn.querySelector('i').style.color = 'red';
  } else {
    heartBtn.querySelector('i').style.fill = 'none';
    heartBtn.querySelector('i').style.color = 'var(--text-primary)';
  }

  // Reviews
  document.getElementById('detail-reviews-count').innerText = `RATINGS & REVIEWS (${product.totalReviews})`;
  document.getElementById('detail-avg-rating').innerText = product.averageRating;
  const list = document.getElementById('detail-reviews-list');
  list.innerHTML = '';
  product.reviews.forEach(rev => {
    const div = document.createElement('div');
    div.className = 'review-box';
    div.innerHTML = `
      <div class="review-meta-row">
        <span>${rev.username}</span>
        <span style="color: #D4AF37;">${'★'.repeat(Math.round(rev.rating))}</span>
      </div>
      <p class="review-comment">${rev.comment}</p>
    `;
    list.appendChild(div);
  });

  lucide.createIcons();
}

// Render Discover / Search
function renderDiscover() {
  const grid = document.getElementById('discover-products-grid');
  grid.innerHTML = '';
  productsData.forEach(p => {
    grid.appendChild(createProductCard(p));
  });
  lucide.createIcons();
}

function renderFilterCategories() {
  const wrap = document.getElementById('filter-categories-wrap');
  wrap.innerHTML = '';
  categoriesData.forEach(c => {
    const pill = document.createElement('span');
    pill.className = `pill cat-filter-pill ${activeFilterCategory === c.id ? 'active' : ''}`;
    pill.innerText = c.name;
    pill.onclick = () => {
      if (activeFilterCategory === c.id) {
        activeFilterCategory = null;
        pill.classList.remove('active');
      } else {
        wrap.querySelectorAll('.cat-filter-pill').forEach(p => p.classList.remove('active'));
        activeFilterCategory = c.id;
        pill.classList.add('active');
      }
    };
    wrap.appendChild(pill);
  });
}

function applyDiscoverFilters() {
  let filtered = [...productsData];
  
  if (activeFilterCategory) {
    filtered = filtered.filter(p => p.categoryId === activeFilterCategory);
  }

  if (activeFilterSize) {
    filtered = filtered.filter(p => p.availableSizes.includes(activeFilterSize));
  }

  // Sort
  if (activeFilterSort === 'asc') {
    filtered.sort((a,b) => a.price - b.price);
  } else if (activeFilterSort === 'desc') {
    filtered.sort((a,b) => b.price - a.price);
  } else {
    // rating
    filtered.sort((a,b) => b.averageRating - a.averageRating);
  }

  const resultsSection = document.getElementById('search-results-section');
  const defaultSection = document.getElementById('discover-default-section');

  resultsSection.style.display = 'block';
  defaultSection.style.display = 'none';
  document.getElementById('search-results-title').innerText = `Filtered Collection (${filtered.length})`;

  const grid = document.getElementById('search-results-grid');
  grid.innerHTML = '';
  filtered.forEach(p => {
    grid.appendChild(createProductCard(p));
  });
  lucide.createIcons();
}

// Calculations for Cart Summary
function calculateSubtotal() {
  let sub = 0;
  cart.forEach(item => sub += item.totalPrice);
  return sub;
}

function calculateDiscount() {
  const sub = calculateSubtotal();
  if (!appliedPromo) return 0;
  
  const val = promoCodes[appliedPromo];
  if (val <= 1) {
    return sub * val; // percentage discount
  } else {
    return Math.min(val, sub); // flat discount
  }
}

function calculateFinalTotal() {
  const sub = calculateSubtotal();
  const disc = calculateDiscount();
  let remaining = sub - disc;
  
  if (useWallet) {
    const walletUsed = Math.min(walletCashback, remaining);
    remaining -= walletUsed;
  }
  
  return Math.max(0, remaining);
}

// Render Cart
function renderCart() {
  const wrapper = document.getElementById('cart-content-wrapper');
  wrapper.innerHTML = '';

  if (cart.length === 0) {
    document.getElementById('cart-action-dock-block').style.display = 'none';
    wrapper.innerHTML = `
      <div class="empty-cart-view">
        <i data-lucide="shopping-bag"></i>
        <h2>Your Bag is Empty</h2>
        <p>Explore HMD mobiles, sneakers, and boutique jackets to fill your shopping bag.</p>
        <button class="primary-btn" style="width: 200px; margin: 0 auto;" id="btn-empty-cart-explore">EXPLORE NOW</button>
      </div>
    `;
    document.getElementById('btn-empty-cart-explore').onclick = () => {
      navigateTo('screen-main');
      navigateToTab('discover');
    };
    lucide.createIcons();
    return;
  }

  document.getElementById('cart-action-dock-block').style.display = 'flex';

  const cartListDiv = document.createElement('div');
  cartListDiv.className = 'cart-items-list';

  cart.forEach((item, idx) => {
    const card = document.createElement('div');
    card.className = 'cart-item-card';
    card.innerHTML = `
      <img src="${item.product.imageUrls[0]}" alt="${item.product.name}">
      <div class="cart-item-meta">
        <h4>${item.product.name}</h4>
        <p>Size: ${item.selectedSize} | Color: ${item.selectedColor}</p>
        <div class="cart-qty-row">
          <div class="qty-selector">
            <button class="qty-btn btn-minus" data-idx="${idx}">-</button>
            <span class="qty-val">${item.quantity}</span>
            <button class="qty-btn btn-plus" data-idx="${idx}">+</button>
          </div>
          <button class="remove-item-btn" data-idx="${idx}">
            <i data-lucide="trash-2" style="width: 16px; height: 16px;"></i>
          </button>
        </div>
        <span class="price">₹${item.totalPrice.toFixed(0)}</span>
      </div>
    `;

    // minus
    card.querySelector('.btn-minus').onclick = () => {
      if (item.quantity > 1) {
        item.quantity--;
        item.totalPrice = item.quantity * item.product.price;
        renderCart();
        updateCartBadges();
      }
    };
    
    // plus
    card.querySelector('.btn-plus').onclick = () => {
      item.quantity++;
      item.totalPrice = item.quantity * item.product.price;
      renderCart();
      updateCartBadges();
    };

    // remove
    card.querySelector('.remove-item-btn').onclick = () => {
      cart.splice(idx, 1);
      renderCart();
      updateCartBadges();
    };

    cartListDiv.appendChild(card);
  });

  wrapper.appendChild(cartListDiv);

  // Promo Area
  const promoDiv = document.createElement('div');
  promoDiv.className = 'cart-promo-area';
  
  let promoBadge = '';
  if (appliedPromo) {
    promoBadge = `
      <div class="promo-success-badge">
        <strong>Coupon "${appliedPromo}" Active</strong>
        <span id="btn-remove-promo">Remove</span>
      </div>
    `;
  } else {
    promoBadge = `
      <div class="promo-input-row">
        <input type="text" id="cart-promo-input" placeholder="Coupon (LUXE10, FIRSTBUY)">
        <button class="primary-btn" id="btn-apply-promo">APPLY</button>
      </div>
    `;
  }

  promoDiv.innerHTML = `
    <h3>PROMO CODE</h3>
    ${promoBadge}
  `;
  wrapper.appendChild(promoDiv);

  // Bind promo triggers
  if (appliedPromo) {
    wrapper.querySelector('#btn-remove-promo').onclick = () => {
      appliedPromo = null;
      renderCart();
    };
  } else {
    wrapper.querySelector('#btn-apply-promo').onclick = () => {
      const code = wrapper.querySelector('#cart-promo-input').value.toUpperCase().trim();
      if (promoCodes[code]) {
        appliedPromo = code;
        renderCart();
      } else {
        alert('Invalid promo code! Try LUXE10 or FIRSTBUY.');
      }
    };
  }

  // Wallet Deduction row
  if (walletCashback > 0) {
    const walletDiv = document.createElement('div');
    walletDiv.className = 'cart-wallet-toggle-row';
    walletDiv.innerHTML = `
      <div class="wallet-toggle-info">
        <i data-lucide="wallet"></i>
        <div>
          <h4>USE WALLET CASHBACK</h4>
          <p>Available Balance: ₹${walletCashback.toFixed(2)}</p>
        </div>
      </div>
      <input type="checkbox" class="custom-switch" id="cart-wallet-switch" ${useWallet ? 'checked' : ''}>
    `;
    wrapper.appendChild(walletDiv);
    
    walletDiv.querySelector('#cart-wallet-switch').onchange = (e) => {
      useWallet = e.target.checked;
      renderCart();
    };
  }

  // Price Summary area
  const summaryDiv = document.createElement('div');
  summaryDiv.className = 'price-summary-area';
  
  const subtotal = calculateSubtotal();
  const discount = calculateDiscount();
  const finalTotal = calculateFinalTotal();
  const walletApplied = useWallet ? Math.min(walletCashback, subtotal - discount) : 0;

  let breakdownHTML = `
    <div class="summary-row">
      <span>Bag Subtotal</span>
      <span>₹${subtotal.toFixed(2)}</span>
    </div>
  `;

  if (discount > 0) {
    breakdownHTML += `
      <div class="summary-row discount">
        <span>Coupon Discount</span>
        <span>- ₹${discount.toFixed(2)}</span>
      </div>
    `;
  }

  if (walletApplied > 0) {
    breakdownHTML += `
      <div class="summary-row wallet">
        <span>Wallet Deduction</span>
        <span>- ₹${walletApplied.toFixed(2)}</span>
      </div>
    `;
  }

  breakdownHTML += `
    <div class="summary-row">
      <span>Delivery Charges</span>
      <span style="color: green; font-weight: bold;">FREE</span>
    </div>
    <div class="summary-row bold">
      <span>Total Amount</span>
      <span>₹${finalTotal.toFixed(2)}</span>
    </div>
  `;

  summaryDiv.innerHTML = breakdownHTML;
  wrapper.appendChild(summaryDiv);

  // Update Action dock
  document.getElementById('cart-dock-total-price').innerText = `₹${finalTotal.toFixed(2)}`;
  lucide.createIcons();
}

// Render Checkout
function renderCheckout() {
  const container = document.getElementById('checkout-addresses-container');
  container.innerHTML = '';

  addresses.forEach((addr, idx) => {
    const card = document.createElement('div');
    card.className = `address-option-card ${selectedAddressIndex === idx ? 'active' : ''}`;
    card.innerHTML = `
      <i data-lucide="${selectedAddressIndex === idx ? 'check-circle-2' : 'circle'}"></i>
      <div class="address-details">
        <h4>${addr.fullName}</h4>
        <p>${addr.streetAddress}, ${addr.city}, ${addr.state} - ${addr.postalCode}</p>
        <span>Mobile: ${addr.phone}</span>
      </div>
    `;
    card.onclick = () => {
      selectedAddressIndex = idx;
      renderCheckout();
    };
    container.appendChild(card);
  });

  // Bind payment method clicks
  document.querySelectorAll('.payment-row').forEach(row => {
    row.onclick = (e) => {
      document.querySelectorAll('.payment-row').forEach(r => {
        r.classList.remove('active');
        r.querySelector('i').setAttribute('data-lucide', 'circle');
      });
      const meth = e.currentTarget.getAttribute('data-method');
      selectedPaymentMethod = meth;
      e.currentTarget.classList.add('active');
      e.currentTarget.querySelector('i').setAttribute('data-lucide', 'circle-dot');
      lucide.createIcons();
    };
  });

  // Order summary recap
  const breakdown = document.getElementById('checkout-summary-breakdown');
  const subtotal = calculateSubtotal();
  const discount = calculateDiscount();
  const finalTotal = calculateFinalTotal();
  const walletApplied = useWallet ? Math.min(walletCashback, subtotal - discount) : 0;

  breakdown.innerHTML = `
    <div class="summary-row">
      <span>Items Subtotal</span>
      <span>₹${subtotal.toFixed(2)}</span>
    </div>
    ${discount > 0 ? `<div class="summary-row discount"><span>Coupon Discount</span><span>- ₹${discount.toFixed(2)}</span></div>` : ''}
    ${walletApplied > 0 ? `<div class="summary-row wallet"><span>Wallet Applied</span><span>- ₹${walletApplied.toFixed(2)}</span></div>` : ''}
    <div class="summary-row">
      <span>Delivery Fee</span>
      <span style="color: green;">FREE</span>
    </div>
  `;

  document.getElementById('checkout-grand-total').innerText = `₹${finalTotal.toFixed(2)}`;
  lucide.createIcons();
}

// Render Order Tracking
function renderOrderTracking(orderId) {
  const order = orders.find(o => o.id === orderId);
  if (!order) return;

  document.getElementById('tracking-title-id').innerText = `ORDER #${order.id}`;
  document.getElementById('tracking-number-val').innerText = order.trackingId.substring(0, 12);
  
  // Status summary Card mapping
  const statusTexts = {
    preparing: 'Preparing Package',
    packed: 'Order Packed',
    shipped: 'Shipped Out',
    outForDelivery: 'Out for Delivery',
    delivered: 'Delivered Successfully'
  };
  document.getElementById('tracking-status-text').innerText = statusTexts[order.status];

  // Address
  document.getElementById('tracking-address-name').innerText = order.deliveryAddress.fullName;
  document.getElementById('tracking-address-full').innerText = 
    `${order.deliveryAddress.streetAddress}, ${order.deliveryAddress.city}, ${order.deliveryAddress.state} - ${order.deliveryAddress.postalCode}`;

  // Item List recap
  const list = document.getElementById('tracking-items-list');
  list.innerHTML = '';
  order.items.forEach(item => {
    const row = document.createElement('div');
    row.className = 'small-item-row';
    row.innerHTML = `
      <span>${item.product.name} (x${item.quantity})</span>
      <strong>₹${item.totalPrice.toFixed(0)}</strong>
    `;
    list.appendChild(row);
  });

  // Timeline Stepper setup
  const statusHierarchy = ['preparing', 'packed', 'shipped', 'outForDelivery', 'delivered'];
  const currentIndex = statusHierarchy.indexOf(order.status);

  statusHierarchy.forEach((st, idx) => {
    const stepDiv = document.getElementById(`step-${idx}`);
    stepDiv.className = 'timeline-step';
    
    if (idx < currentIndex) {
      stepDiv.classList.add('completed');
    } else if (idx === currentIndex) {
      stepDiv.classList.add('active');
    }
  });

  lucide.createIcons();
}

// Render Wallet
function renderWallet() {
  document.getElementById('wallet-balance-val').innerText = `₹${walletCashback.toFixed(2)}`;
  document.getElementById('wallet-points-val').innerText = `${walletPoints.toFixed(0)} pts`;
  document.getElementById('wallet-referrals-val').innerText = `₹${walletReferrals.toFixed(2)}`;

  // Scratch card wrapper visibility
  const scratchBox = document.querySelector('.scratch-card-box');
  if (scratchUnlocked) {
    scratchBox.style.display = 'none';
  } else {
    scratchBox.style.display = 'flex';
  }

  // Transactions logs
  const list = document.getElementById('transactions-container');
  list.innerHTML = '';

  if (walletTransactions.length === 0) {
    list.innerHTML = `<p style="text-align: center; padding: 20px; font-size: 12px; color: var(--text-muted);">No logs found.</p>`;
  } else {
    walletTransactions.forEach(tx => {
      const row = document.createElement('div');
      row.className = 'tx-row';
      row.innerHTML = `
        <div class="tx-info">
          <h4>${tx.description}</h4>
          <span>${tx.timestamp}</span>
        </div>
        <span class="tx-amount ${tx.isCredit ? 'credit' : 'debit'}">
          ${tx.isCredit ? '+' : '-'} ₹${tx.amount.toFixed(0)}
        </span>
      `;
      list.appendChild(row);
    });
  }

  // Claim referral logic
  document.getElementById('btn-claim-referral').onclick = () => {
    const code = document.getElementById('referral-code-input').value.trim();
    if (promoCodes[code] === 50) {
      walletCashback += 50.0;
      walletTransactions.unshift({
        description: 'Referral reward voucher claimed',
        amount: 50.0,
        timestamp: '2026-05-21',
        isCredit: true
      });
      document.getElementById('referral-code-input').value = '';
      renderWallet();
      alert('Congratulations! ₹50 claimed successfully.');
    } else {
      alert('Invalid or expired referral code.');
    }
  };

  lucide.createIcons();
}

// Render Profile
function renderProfile() {
  const orderCount = orders.length;
  let rank = 'SILVER STANDARD';
  if (orderCount >= 10) rank = 'PLATINUM ELITE';
  else if (orderCount >= 5) rank = 'GOLD MEMBER';

  document.getElementById('profile-rank').innerText = rank;

  // Render orders history
  const list = document.getElementById('profile-orders-list');
  list.innerHTML = '';

  orders.forEach(o => {
    const div = document.createElement('div');
    div.className = 'order-history-row';
    div.onclick = () => {
      navigateTo('screen-order-tracking');
      renderOrderTracking(o.id);
    };

    div.innerHTML = `
      <img src="${o.items[0].product.imageUrls[0]}" alt="${o.items[0].product.name}">
      <div class="order-hist-meta">
        <h4>Order #${o.id}</h4>
        <p>Placed on: ${o.orderDate}</p>
        <span class="order-hist-status ${o.status}">${o.status}</span>
      </div>
      <i data-lucide="chevron-right"></i>
    `;
    list.appendChild(div);
  });

  // Action links
  document.getElementById('btn-profile-wishlist').onclick = () => {
    navigateToTab('discover');
  };

  document.getElementById('btn-profile-wallet').onclick = () => {
    navigateToTab('wallet');
  };

  document.getElementById('btn-profile-vouchers').onclick = () => {
    navigateTo('screen-cart');
    renderCart();
  };

  lucide.createIcons();
}

// Render Admin Dashboard Console
function renderAdminDashboard() {
  // Tabs switcher
  document.querySelectorAll('.admin-tab').forEach(tab => {
    tab.onclick = (e) => {
      document.querySelectorAll('.admin-tab').forEach(t => t.classList.remove('active'));
      document.querySelectorAll('.admin-sub-tab').forEach(st => st.classList.remove('active'));
      
      e.target.classList.add('active');
      const targetSub = e.target.getAttribute('data-tab');
      document.getElementById(`admin-tab-${targetSub}`).classList.add('active');
    };
  });

  // TAB 1: Analytics metrics calculation
  let revenue = 0;
  let unitCount = 0;
  orders.forEach(o => {
    revenue += o.paidAmount;
    o.items.forEach(item => unitCount += item.quantity);
  });

  document.getElementById('admin-total-revenue').innerText = `₹${revenue.toFixed(0)}`;
  document.getElementById('admin-total-orders').innerText = orders.length;
  document.getElementById('admin-units-dispatched').innerText = unitCount;
  document.getElementById('admin-cashback-given').innerText = `₹${walletCashback.toFixed(0)}`;

  // TAB 2: Inventory manager
  const invList = document.getElementById('admin-inventory-list');
  invList.innerHTML = '';
  productsData.forEach(prod => {
    const row = document.createElement('div');
    row.className = 'inventory-row';
    const isLow = prod.stockCount < 10;
    
    row.innerHTML = `
      <img src="${prod.imageUrls[0]}" alt="${prod.name}">
      <div class="inventory-meta">
        <h4>${prod.name}</h4>
        <p>Price: ₹${prod.price.toFixed(0)}</p>
        <span class="inventory-stock ${isLow ? 'low' : 'normal'}">
          STOCK: ${prod.stockCount} ${isLow ? '(LOW STOCK)' : ''}
        </span>
      </div>
      <div class="inventory-actions">
        <button class="btn-add-stock" data-id="${prod.id}">+</button>
        <button class="btn-sub-stock" data-id="${prod.id}">-</button>
      </div>
      <button class="btn-delete-prod" data-id="${prod.id}">
        <i data-lucide="trash-2" style="width: 18px; height: 18px;"></i>
      </button>
    `;

    // plus stock
    row.querySelector('.btn-add-stock').onclick = () => {
      prod.stockCount += 5;
      renderAdminDashboard();
      if (selectedProduct && selectedProduct.id === prod.id) selectedProduct.stockCount = prod.stockCount;
    };

    // sub stock
    row.querySelector('.btn-sub-stock').onclick = () => {
      if (prod.stockCount > 0) {
        prod.stockCount -= 1;
        renderAdminDashboard();
        if (selectedProduct && selectedProduct.id === prod.id) selectedProduct.stockCount = prod.stockCount;
      }
    };

    // delete product
    row.querySelector('.btn-delete-prod').onclick = () => {
      const idx = productsData.findIndex(p => p.id === prod.id);
      if (idx >= 0) {
        productsData.splice(idx, 1);
        renderAdminDashboard();
        renderHome();
      }
    };

    invList.appendChild(row);
  });

  // Add mock product
  document.getElementById('btn-admin-add-product').onclick = () => {
    const newP = {
      id: 'prod_' + Date.now(),
      name: 'Aura Premium Leather Slides',
      description: 'Handcrafted minimal slides featuring ergonomic cork footbeds.',
      price: 4999.0,
      categoryId: 'cat2',
      imageUrls: ['https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=800&q=80'],
      availableSizes: ['UK 8', 'UK 9'],
      availableColors: ['Tan Brown', 'Stealth Black'],
      averageRating: 4.7,
      totalReviews: 12,
      reviews: [],
      stockCount: 15
    };
    productsData.unshift(newP);
    renderAdminDashboard();
    renderHome();
    alert('Mock product added to Store catalog inventory.');
  };

  // TAB 3: Orders Status overrides
  const ordersContainer = document.getElementById('admin-orders-container');
  ordersContainer.innerHTML = '';

  orders.forEach(o => {
    const box = document.createElement('div');
    box.className = 'admin-order-box';
    
    box.innerHTML = `
      <div class="admin-order-header">
        <span>Order #${o.id}</span>
        <span class="order-status-lbl">${o.status.toUpperCase()}</span>
      </div>
      <div class="admin-order-body">
        <p>Buyer: ${o.deliveryAddress.fullName} (${o.deliveryAddress.city})</p>
        <p>Amount paid: ₹${o.paidAmount.toFixed(2)} via ${o.paymentMethod}</p>
      </div>
      <div class="admin-order-status-row">
        <span>Advance Status:</span>
        <select class="status-dropdown" data-id="${o.id}">
          <option value="preparing" ${o.status === 'preparing' ? 'selected' : ''}>Preparing</option>
          <option value="packed" ${o.status === 'packed' ? 'selected' : ''}>Packed</option>
          <option value="shipped" ${o.status === 'shipped' ? 'selected' : ''}>Shipped</option>
          <option value="outForDelivery" ${o.status === 'outForDelivery' ? 'selected' : ''}>Out For Delivery</option>
          <option value="delivered" ${o.status === 'delivered' ? 'selected' : ''}>Delivered</option>
        </select>
      </div>
    `;

    // change status dropdown
    box.querySelector('.status-dropdown').onchange = (e) => {
      const newStatus = e.target.value;
      o.status = newStatus;
      box.querySelector('.order-status-lbl').innerText = newStatus.toUpperCase();
      alert(`Order #${o.id} status updated to: ${newStatus.toUpperCase()}`);
      
      // If we are currently looking at this order tracking page, update it!
      if (currentActiveScreen === 'screen-order-tracking') {
        renderOrderTracking(o.id);
      }
    };

    ordersContainer.appendChild(box);
  });

  lucide.createIcons();
}

window.onload = initApp;
