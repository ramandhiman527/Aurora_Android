import React from 'react';
import { 
  DollarSign, 
  ShoppingBag, 
  Users, 
  AlertTriangle,
  ArrowUpRight,
  TrendingUp,
  Percent,
  Clock
} from 'lucide-react';
import SalesCharts from './SalesCharts';

export default function DashboardOverview({ 
  products = [], 
  orders = [], 
  customers = [], 
  promos = [],
  isDarkMode,
  setActivePage
}) {
  // --- STATS CALCULATIONS ---
  const totalRevenue = orders.reduce((sum, order) => sum + (order.paidAmount || 0), 0);
  const totalOrders = orders.length;
  
  // Total units dispatched
  const totalUnits = orders.reduce((sum, order) => {
    return sum + (order.items?.reduce((itemSum, item) => itemSum + (item.quantity || 0), 0) || 0);
  }, 0);

  // Total active users
  const totalCustomers = customers.length;

  // Stock warning count (stock <= 12)
  const lowStockItems = products.filter(p => p.stockCount <= 12);
  const lowStockCount = lowStockItems.length;

  const statCards = [
    {
      title: 'Total Gross Revenue',
      value: `₹${totalRevenue.toLocaleString('en-IN', { maximumFractionDigits: 2 })}`,
      icon: DollarSign,
      iconClass: 'icon-blue',
      subText: 'Realized paid balances',
      trend: <span className="trend-up"><TrendingUp size={12} style={{ display: 'inline', marginRight: '4px' }} /> +18.4%</span>
    },
    {
      title: 'Store Purchase Orders',
      value: totalOrders,
      icon: ShoppingBag,
      iconClass: 'icon-orange',
      subText: 'Pending & fulfilled checkouts',
      trend: <span className="trend-up"><TrendingUp size={12} style={{ display: 'inline', marginRight: '4px' }} /> +12.5%</span>
    },
    {
      title: 'Customer Directory',
      value: totalCustomers,
      icon: Users,
      iconClass: 'icon-purple',
      subText: 'FCM push-ready accounts',
      trend: <span className="trend-up"><TrendingUp size={12} style={{ display: 'inline', marginRight: '4px' }} /> +5.2%</span>
    },
    {
      title: 'Low Stock Catalog Items',
      value: lowStockCount,
      icon: AlertTriangle,
      iconClass: lowStockCount > 0 ? 'icon-red animate-pulse-slow' : 'icon-green',
      subText: 'Stock count <= 12 units',
      trend: lowStockCount > 0 
        ? <span className="trend-down" style={{ color: 'var(--danger-color)' }}>Needs Refurbish</span>
        : <span className="trend-up">Safe Stock</span>
    }
  ];

  return (
    <div className="animate-fade-in">
      {/* Analytics Metric Cards Grid */}
      <div className="metrics-grid">
        {statCards.map((card, index) => {
          const IconComp = card.icon;
          return (
            <div key={index} className="card metric-card">
              <div className="metric-header">
                <span className="metric-title">{card.title}</span>
                <div className={`metric-icon-wrap ${card.iconClass}`}>
                  <IconComp size={18} />
                </div>
              </div>
              <div className="metric-value">{card.value}</div>
              <div className="metric-sub" style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <span>{card.subText}</span>
                {card.trend}
              </div>
            </div>
          );
        })}
      </div>

      {/* Main Revenue & Stock charts */}
      <SalesCharts isDarkMode={isDarkMode} orders={orders} products={products} />

      {/* Double Column Info Section */}
      <div className="dashboard-grid" style={{ marginTop: '24px' }}>
        {/* Recent Orders Card */}
        <div className="card">
          <div className="card-header">
            <h3 className="card-title">Recent Purchase Orders</h3>
            <button className="btn btn-secondary small-btn" onClick={() => setActivePage('orders')}>
              Review All <ArrowUpRight size={14} />
            </button>
          </div>
          
          <div className="table-container">
            <table className="admin-table">
              <thead>
                <tr>
                  <th>Order ID</th>
                  <th>Customer</th>
                  <th>Date</th>
                  <th>Grand Total</th>
                  <th>Status</th>
                </tr>
              </thead>
              <tbody>
                {orders.slice(0, 4).map((order) => (
                  <tr key={order.id}>
                    <td style={{ fontWeight: '600' }}>#{order.id}</td>
                    <td>{order.customerName || 'Loyal Client'}</td>
                    <td>
                      <span style={{ fontSize: '11px', color: 'var(--text-muted)' }}>
                        {new Date(order.orderDate).toLocaleDateString('en-IN', {
                          month: 'short',
                          day: 'numeric'
                        })}
                      </span>
                    </td>
                    <td style={{ fontWeight: '600' }}>₹{order.paidAmount?.toFixed(2)}</td>
                    <td>
                      <span className={`badge ${
                        order.status === 'delivered' ? 'badge-success' :
                        order.status === 'preparing' ? 'badge-info' :
                        'badge-warning'
                      }`}>
                        {order.status}
                      </span>
                    </td>
                  </tr>
                ))}
                {orders.length === 0 && (
                  <tr>
                    <td colSpan="5" style={{ textAlign: 'center', padding: '20px', color: 'var(--text-muted)' }}>
                      No recent orders recorded.
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        </div>

        {/* Low Stock Alerts & Fast Coupons */}
        <div className="flex-col" style={{ gap: '24px' }}>
          {/* Stock Alerts Card */}
          <div className="card" style={{ flex: 1 }}>
            <div className="card-header">
              <h3 className="card-title">Critical Inventory Alerts</h3>
              <button className="btn btn-secondary small-btn" onClick={() => setActivePage('products')}>
                Manage Catalog
              </button>
            </div>
            
            <div style={{ display: 'flex', flexDirection: 'column', gap: '14px', marginTop: '10px' }}>
              {lowStockItems.slice(0, 3).map((item) => (
                <div key={item.id} style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', paddingBottom: '10px', borderBottom: '1px solid var(--border-color)' }}>
                  <div>
                    <h4 style={{ fontSize: '13px', fontWeight: '600' }}>{item.name}</h4>
                    <span style={{ fontSize: '11px', color: 'var(--text-muted)' }}>ID: {item.id} • SKU Stock</span>
                  </div>
                  <div style={{ textAlign: 'right' }}>
                    <span className="badge badge-danger" style={{ fontWeight: '700', borderRadius: '4px' }}>
                      {item.stockCount} left
                    </span>
                    <p style={{ fontSize: '11px', color: 'var(--text-muted)', marginTop: '2px' }}>₹{item.price}</p>
                  </div>
                </div>
              ))}
              {lowStockCount === 0 && (
                <p style={{ textAlign: 'center', color: 'var(--text-muted)', padding: '16px 0', fontSize: '12px' }}>
                  🎉 All catalog inventory items are above safe levels.
                </p>
              )}
            </div>
          </div>

          {/* Active Promo Codes List */}
          <div className="card">
            <div className="card-header">
              <h3 className="card-title">Active Discount Vouchers</h3>
              <button className="btn btn-secondary small-btn" onClick={() => setActivePage('wallet-coupons')}>
                Coupons
              </button>
            </div>

            <div style={{ display: 'flex', flexDirection: 'column', gap: '12px', marginTop: '8px' }}>
              {promos.slice(0, 3).map((promo) => (
                <div key={promo.code} style={{ display: 'flex', alignItems: 'center', justifyItems: 'center', gap: '12px' }}>
                  <div style={{ 
                    padding: '8px 10px', 
                    borderRadius: '6px', 
                    background: 'linear-gradient(135deg, rgba(52,199,89,0.1), rgba(52,199,89,0.05))',
                    border: '1px dashed var(--success-color)',
                    color: 'var(--success-color)',
                    fontFamily: 'monospace',
                    fontWeight: '700',
                    fontSize: '12px'
                  }}>
                    {promo.code}
                  </div>
                  <div style={{ flex: 1 }}>
                    <h4 style={{ fontSize: '12px', fontWeight: '600' }}>
                      {promo.type === 'percentage' ? `${promo.value}% Off` : `₹${promo.value} Flat Off`}
                    </h4>
                    <p style={{ fontSize: '11px', color: 'var(--text-muted)' }}>{promo.description}</p>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
