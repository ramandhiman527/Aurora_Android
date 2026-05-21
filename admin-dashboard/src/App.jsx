import React, { useState, useEffect } from 'react';
import { dbService as api } from './firebase/db';
import Sidebar from './components/Sidebar';
import Auth from './components/Auth';
import DashboardOverview from './components/DashboardOverview';
import ProductManagement from './components/ProductManagement';
import OrderManagement from './components/OrderManagement';
import CustomerManagement from './components/CustomerManagement';
import WalletCouponManagement from './components/WalletCouponManagement';
import NotificationManagement from './components/NotificationManagement';
import DeliveryTracking from './components/DeliveryTracking';
import { Menu, User, ShieldCheck, RefreshCw } from 'lucide-react';

export default function App() {
  const [isAuthenticated, setIsAuthenticated] = useState(() => {
    return localStorage.getItem('aura_admin_logged') === 'true';
  });
  
  const [activePage, setActivePage] = useState('dashboard');
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const [isDarkMode, setIsDarkMode] = useState(() => {
    return localStorage.getItem('aura_admin_theme') === 'dark';
  });

  // DB States
  const [products, setProducts] = useState([]);
  const [orders, setOrders] = useState([]);
  const [customers, setCustomers] = useState([]);
  const [categories, setCategories] = useState([]);
  const [promoCodes, setPromoCodes] = useState([]);
  const [transactions, setTransactions] = useState([]);
  const [isLoading, setIsLoading] = useState(false);

  // Sync theme with body class
  useEffect(() => {
    if (isDarkMode) {
      document.body.classList.add('dark-mode');
      localStorage.setItem('aura_admin_theme', 'dark');
    } else {
      document.body.classList.remove('dark-mode');
      localStorage.setItem('aura_admin_theme', 'light');
    }
  }, [isDarkMode]);

  // Fetch initial database documents
  const loadDatabase = async () => {
    setIsLoading(true);
    try {
      const [prods, ords, custs, cats, promos, txs] = await Promise.all([
        api.getProducts(),
        api.getOrders(),
        api.getCustomers(),
        api.getCategories(),
        api.getPromoCodes(),
        api.getWalletTransactions()
      ]);

      // Sort lists chronologically
      setProducts(prods);
      setOrders(ords.sort((a, b) => new Date(b.orderDate) - new Date(a.orderDate)));
      setCustomers(custs);
      setCategories(cats);
      setPromoCodes(promos);
      setTransactions(txs.sort((a, b) => new Date(b.timestamp) - new Date(a.timestamp)));
    } catch (error) {
      console.error('Failed to sync databases:', error);
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    if (isAuthenticated) {
      loadDatabase();
    }
  }, [isAuthenticated]);

  const handleLoginSuccess = () => {
    setIsAuthenticated(true);
    localStorage.setItem('aura_admin_logged', 'true');
  };

  const handleLogout = () => {
    setIsAuthenticated(false);
    localStorage.removeItem('aura_admin_logged');
  };

  // --- CRUD DISPATCHERS ---

  const handleAddProduct = async (productData) => {
    try {
      const newProduct = await api.addProduct(productData);
      setProducts(prev => [newProduct, ...prev]);
    } catch (err) {
      console.error(err);
      alert('Error adding product: ' + err.message);
    }
  };

  const handleUpdateProduct = async (id, productData) => {
    try {
      const updated = await api.updateProduct(id, productData);
      setProducts(prev => prev.map(p => p.id === id ? updated : p));
    } catch (err) {
      console.error(err);
      alert('Error updating product: ' + err.message);
    }
  };

  const handleDeleteProduct = async (id) => {
    try {
      await api.deleteProduct(id);
      setProducts(prev => prev.filter(p => p.id !== id));
    } catch (err) {
      console.error(err);
      alert('Error deleting product: ' + err.message);
    }
  };

  const handleUpdateOrderStatus = async (orderId, newStatus) => {
    try {
      const updatedOrder = await api.updateOrderStatus(orderId, newStatus);
      setOrders(prev => prev.map(o => o.id === orderId ? { ...o, status: newStatus } : o));
    } catch (err) {
      console.error(err);
      alert('Error updating order status: ' + err.message);
    }
  };

  const handleUpdateCustomerRank = async (uid, newRank) => {
    try {
      await api.updateCustomerRank(uid, newRank);
      setCustomers(prev => prev.map(c => c.uid === uid ? { ...c, customerRank: newRank } : c));
    } catch (err) {
      console.error(err);
      alert('Error updating customer rank: ' + err.message);
    }
  };

  const handleAddPromoCode = async (promoData) => {
    try {
      const newPromo = await api.addPromoCode(promoData);
      setPromoCodes(prev => [newPromo, ...prev]);
    } catch (err) {
      console.error(err);
      alert('Error adding coupon: ' + err.message);
    }
  };

  const handleDeletePromoCode = async (id) => {
    try {
      await api.deletePromoCode(id);
      setPromoCodes(prev => prev.filter(p => p.id !== id && p.code !== id));
    } catch (err) {
      console.error(err);
      alert('Error deleting coupon: ' + err.message);
    }
  };

  const handleAdjustWallet = async (uid, amount, type, isCredit) => {
    try {
      const updatedCustomer = await api.adjustCustomerWallet(uid, amount, type, isCredit);
      
      // Refresh customer and ledger details
      setCustomers(prev => prev.map(c => c.uid === uid ? {
        ...c,
        walletCashback: updatedCustomer.walletCashback,
        walletPoints: updatedCustomer.walletPoints
      } : c));

      // Reload transactions
      const txs = await api.getWalletTransactions();
      setTransactions(txs.sort((a, b) => new Date(b.timestamp) - new Date(a.timestamp)));
    } catch (err) {
      console.error(err);
      alert('Error adjusting customer wallet: ' + err.message);
    }
  };

  const handleUpdateOrderTracking = async (orderId, trackingData) => {
    try {
      await api.updateOrderTracking(orderId, trackingData);
      setOrders(prev => prev.map(o => o.id === orderId ? {
        ...o,
        trackingId: trackingData.trackingId,
        deliveryPartner: trackingData.deliveryPartner,
        estimatedDelivery: trackingData.estimatedDelivery,
        status: trackingData.status
      } : o));
    } catch (err) {
      console.error(err);
      alert('Error updating order tracking: ' + err.message);
    }
  };

  // --- RENDER ROUTED PAGE ---
  const renderPage = () => {
    if (isLoading) {
      return (
        <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', minHeight: '60vh', gap: '16px' }}>
          <RefreshCw className="animate-spin" size={32} style={{ color: 'var(--accent-color)', animation: 'spin 1.5s linear infinite' }} />
          <p style={{ color: 'var(--text-secondary)', fontSize: '14px', fontWeight: '500' }}>Synchronizing Firestore collections...</p>
        </div>
      );
    }

    switch (activePage) {
      case 'dashboard':
        return (
          <DashboardOverview
            products={products}
            orders={orders}
            customers={customers}
            promos={promoCodes}
            isDarkMode={isDarkMode}
            setActivePage={setActivePage}
          />
        );
      case 'products':
        return (
          <ProductManagement
            products={products}
            categories={categories}
            onAdd={handleAddProduct}
            onUpdate={handleUpdateProduct}
            onDelete={handleDeleteProduct}
          />
        );
      case 'orders':
        return (
          <OrderManagement
            orders={orders}
            onUpdateStatus={handleUpdateOrderStatus}
          />
        );
      case 'customers':
        return (
          <CustomerManagement
            customers={customers}
            onUpdateRank={handleUpdateCustomerRank}
          />
        );
      case 'wallet-coupons':
        return (
          <WalletCouponManagement
            promos={promoCodes}
            customers={customers}
            transactions={transactions}
            onAddPromo={handleAddPromoCode}
            onDeletePromo={handleDeletePromoCode}
            onAdjustWallet={handleAdjustWallet}
          />
        );
      case 'notifications':
        return <NotificationManagement />;
      case 'tracking':
        return (
          <DeliveryTracking
            orders={orders}
            onUpdateTracking={handleUpdateOrderTracking}
          />
        );
      default:
        return <div style={{ padding: '24px' }}>Page not found</div>;
    }
  };

  if (!isAuthenticated) {
    return <Auth onLoginSuccess={handleLoginSuccess} />;
  }

  const getPageTitle = () => {
    switch (activePage) {
      case 'dashboard': return 'Admin Analytics';
      case 'products': return 'Drop Catalogue';
      case 'orders': return 'Sales Invoices';
      case 'customers': return 'VIP Registry';
      case 'wallet-coupons': return 'Vouchers & Ledgers';
      case 'notifications': return 'FCM Broadcaster';
      case 'tracking': return 'Shipment Hub';
      default: return 'Aura Dashboard';
    }
  };

  return (
    <div className="admin-container">
      {/* Sidebar Navigation */}
      <Sidebar
        activePage={activePage}
        setActivePage={setActivePage}
        onLogout={handleLogout}
        sidebarOpen={sidebarOpen}
        setSidebarOpen={setSidebarOpen}
        isDarkMode={isDarkMode}
        setIsDarkMode={setIsDarkMode}
      />

      {/* Main Panel Content */}
      <main className="main-content">
        {/* Global Concierge Top Bar */}
        <div 
          style={{ 
            display: 'flex', 
            justifyContent: 'space-between', 
            alignItems: 'center', 
            marginBottom: '28px',
            borderBottom: '1px solid var(--border-color)',
            paddingBottom: '16px'
          }}
        >
          <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
            <button 
              className="btn-icon mobile-only" 
              onClick={() => setSidebarOpen(true)}
              style={{ display: 'none' }} // styled by class media query in index.css
            >
              <Menu size={20} />
            </button>
            
            <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
              <ShieldCheck size={20} color="var(--success-color)" />
              <span style={{ fontSize: '11px', letterSpacing: '1px', fontWeight: '800', textTransform: 'uppercase', color: 'var(--text-muted)' }}>
                Concierge Secure Connection
              </span>
            </div>
          </div>

          <div style={{ display: 'flex', alignItems: 'center', gap: '14px' }}>
            {/* Sync DB manual reload */}
            <button 
              className="btn btn-secondary" 
              onClick={loadDatabase} 
              disabled={isLoading}
              style={{ padding: '8px 12px', borderRadius: '20px', fontSize: '12px' }}
              title="Sync Database"
            >
              <RefreshCw size={14} className={isLoading ? "animate-spin" : ""} style={{ animation: isLoading ? 'spin 1.5s linear infinite' : 'none' }} />
              Sync
            </button>

            <div style={{ display: 'flex', alignItems: 'center', gap: '8px', fontSize: '13px', fontWeight: '500' }}>
              <div className="avatar-circle" style={{ width: '28px', height: '28px', fontSize: '10px' }}>
                AD
              </div>
              <span className="desktop-only">Aura Admin</span>
            </div>
          </div>
        </div>

        {/* Dynamic Render Section */}
        {renderPage()}
      </main>

      {/* Keyframe spinners helper for Vite development compilation */}
      <style>{`
        @keyframes spin {
          from { transform: rotate(0deg); }
          to { transform: rotate(360deg); }
        }
        @media (max-width: 768px) {
          .mobile-only {
            display: flex !important;
          }
          .desktop-only {
            display: none !important;
          }
        }
      `}</style>
    </div>
  );
}
