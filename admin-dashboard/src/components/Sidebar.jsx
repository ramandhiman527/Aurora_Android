import React from 'react';
import { 
  LayoutDashboard, 
  ShoppingBag, 
  Receipt, 
  Users, 
  Wallet, 
  Bell, 
  Truck, 
  LogOut,
  Sun,
  Moon,
  X
} from 'lucide-react';

export default function Sidebar({ 
  activePage, 
  setActivePage, 
  onLogout, 
  sidebarOpen, 
  setSidebarOpen,
  isDarkMode,
  setIsDarkMode
}) {
  const menuItems = [
    { id: 'dashboard', label: 'Dashboard', icon: LayoutDashboard },
    { id: 'products', label: 'Products', icon: ShoppingBag },
    { id: 'orders', label: 'Orders', icon: Receipt },
    { id: 'customers', label: 'Customers', icon: Users },
    { id: 'wallet-coupons', label: 'Coupons & Wallet', icon: Wallet },
    { id: 'notifications', label: 'Push Broadcasts', icon: Bell },
    { id: 'tracking', label: 'Delivery Tracking', icon: Truck },
  ];

  return (
    <aside className={`sidebar ${sidebarOpen ? 'mobile-open' : ''}`}>
      <div className="sidebar-header">
        <div className="sidebar-logo">AURA</div>
        <span className="sidebar-badge">ADMIN</span>
        <button 
          className="btn-icon mobile-only" 
          onClick={() => setSidebarOpen(false)}
          style={{ display: 'none' /* Will override in responsive CSS if needed */ }}
        >
          <X size={18} />
        </button>
      </div>

      <ul className="sidebar-menu">
        {menuItems.map((item) => {
          const IconComponent = item.icon;
          return (
            <li key={item.id} className="sidebar-item">
              <a
                className={`sidebar-link ${activePage === item.id ? 'active' : ''}`}
                onClick={() => {
                  setActivePage(item.id);
                  setSidebarOpen(false);
                }}
              >
                <IconComponent />
                <span>{item.label}</span>
              </a>
            </li>
          );
        })}
      </ul>

      <div className="sidebar-footer">
        <div 
          className="sidebar-link" 
          onClick={() => setIsDarkMode(!isDarkMode)}
          style={{ marginBottom: '12px', padding: '8px 16px' }}
        >
          {isDarkMode ? <Sun size={18} /> : <Moon size={18} />}
          <span>{isDarkMode ? 'Light Mode' : 'Dark Mode'}</span>
        </div>
        
        <a className="sidebar-link" onClick={onLogout} style={{ color: 'var(--danger-color)' }}>
          <LogOut />
          <span>Sign Out</span>
        </a>
      </div>
    </aside>
  );
}
