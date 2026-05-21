import React, { useState } from 'react';
import { Search, Eye, Clipboard, HelpCircle } from 'lucide-react';

export default function OrderManagement({ orders = [], onUpdateStatus }) {
  const [searchTerm, setSearchTerm] = useState('');
  const [activeStatusTab, setActiveStatusTab] = useState('all');
  const [selectedOrder, setSelectedOrder] = useState(null); // object for details modal

  // Filtering
  const filteredOrders = orders.filter(order => {
    const matchesSearch = 
      order.id?.toLowerCase().includes(searchTerm.toLowerCase()) || 
      order.customerName?.toLowerCase().includes(searchTerm.toLowerCase()) ||
      order.trackingId?.toLowerCase().includes(searchTerm.toLowerCase());

    const matchesStatus = activeStatusTab === 'all' ? true : order.status === activeStatusTab;
    return matchesSearch && matchesStatus;
  });

  const handleStatusChange = (orderId, newStatus) => {
    onUpdateStatus(orderId, newStatus);
    
    // If the modal is open, update its local order state too
    if (selectedOrder && selectedOrder.id === orderId) {
      setSelectedOrder(prev => ({
        ...prev,
        status: newStatus
      }));
    }
  };

  const statusTones = {
    preparing: 'badge-info',
    packed: 'badge-warning',
    shipped: 'badge-warning',
    outForDelivery: 'badge-info',
    delivered: 'badge-success'
  };

  const statusOptions = [
    { value: 'preparing', label: 'Preparing package' },
    { value: 'packed', label: 'Order Packed' },
    { value: 'shipped', label: 'Shipped Out' },
    { value: 'outForDelivery', label: 'Out For Delivery' },
    { value: 'delivered', label: 'Delivered' }
  ];

  return (
    <div className="animate-fade-in">
      {/* Controls row */}
      <div className="header-controls" style={{ justifyContent: 'space-between', marginBottom: '24px', width: '100%' }}>
        <div style={{ position: 'relative', flex: 1, maxWidth: '400px' }}>
          <Search size={16} style={{ position: 'absolute', left: '12px', top: '13px', color: 'var(--text-muted)' }} />
          <input 
            type="text" 
            className="input-control w-full" 
            placeholder="Search orders by Order ID, customer, tracking..." 
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            style={{ paddingLeft: '40px' }}
          />
        </div>

        {/* Status filtering pills */}
        <div className="pills-container">
          <span className={`pill ${activeStatusTab === 'all' ? 'active' : ''}`} onClick={() => setActiveStatusTab('all')}>All Orders</span>
          <span className={`pill ${activeStatusTab === 'preparing' ? 'active' : ''}`} onClick={() => setActiveStatusTab('preparing')}>Preparing</span>
          <span className={`pill ${activeStatusTab === 'packed' ? 'active' : ''}`} onClick={() => setActiveStatusTab('packed')}>Packed</span>
          <span className={`pill ${activeStatusTab === 'shipped' ? 'active' : ''}`} onClick={() => setActiveStatusTab('shipped')}>Shipped</span>
          <span className={`pill ${activeStatusTab === 'outForDelivery' ? 'active' : ''}`} onClick={() => setActiveStatusTab('outForDelivery')}>Out for Delivery</span>
          <span className={`pill ${activeStatusTab === 'delivered' ? 'active' : ''}`} onClick={() => setActiveStatusTab('delivered')}>Delivered</span>
        </div>
      </div>

      {/* Orders List Card */}
      <div className="card">
        <div className="card-header">
          <h3 className="card-title">Order Records ({filteredOrders.length} Found)</h3>
        </div>

        <div className="table-container">
          <table className="admin-table">
            <thead>
              <tr>
                <th>Order ID</th>
                <th>Client Name</th>
                <th>Purchased Date</th>
                <th>Items Count</th>
                <th>Grand Total</th>
                <th>Payment Option</th>
                <th>Status Stage</th>
                <th style={{ textAlign: 'right' }}>Management Actions</th>
              </tr>
            </thead>
            <tbody>
              {filteredOrders.map((order) => {
                const totalQuantity = order.items?.reduce((sum, item) => sum + (item.quantity || 1), 0) || 0;
                
                return (
                  <tr key={order.id}>
                    <td style={{ fontWeight: '600' }}>#{order.id}</td>
                    <td>{order.customerName || 'Loyal Client'}</td>
                    <td>
                      <span style={{ fontSize: '12px' }}>
                        {new Date(order.orderDate).toLocaleString('en-IN', {
                          month: 'short',
                          day: 'numeric',
                          hour: '2-digit',
                          minute: '2-digit'
                        })}
                      </span>
                    </td>
                    <td>{totalQuantity} {totalQuantity === 1 ? 'item' : 'items'}</td>
                    <td style={{ fontWeight: '600' }}>₹{order.paidAmount?.toFixed(2)}</td>
                    <td>
                      <span style={{ fontSize: '11px', fontFamily: 'monospace', fontWeight: 'bold' }}>
                        {order.paymentMethod}
                      </span>
                    </td>
                    <td>
                      <select 
                        className={`input-control badge ${statusTones[order.status] || 'badge-info'}`}
                        value={order.status}
                        onChange={(e) => handleStatusChange(order.id, e.target.value)}
                        style={{ border: 'none', cursor: 'pointer', paddingRight: '20px', fontWeight: '700' }}
                      >
                        {statusOptions.map(opt => (
                          <option key={opt.value} value={opt.value} style={{ background: 'var(--bg-secondary)', color: 'var(--text-primary)' }}>
                            {opt.label}
                          </option>
                        ))}
                      </select>
                    </td>
                    <td>
                      <div style={{ display: 'flex', gap: '8px', justifyContent: 'flex-end' }}>
                        <button className="btn btn-secondary small-btn" onClick={() => setSelectedOrder(order)} style={{ padding: '6px 12px', gap: '4px' }}>
                          <Eye size={12} /> Inspect
                        </button>
                      </div>
                    </td>
                  </tr>
                );
              })}
              {filteredOrders.length === 0 && (
                <tr>
                  <td colSpan="8" style={{ textAlign: 'center', padding: '36px 0', color: 'var(--text-muted)' }}>
                    No purchase orders found matching selections.
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      </div>

      {/* INSPECT ORDER DETAILS MODAL */}
      {selectedOrder && (
        <div className="modal-overlay">
          <div className="modal-content" style={{ maxWidth: '680px' }}>
            <div className="modal-header">
              <div>
                <h3 style={{ fontSize: '18px', fontWeight: '700' }}>Order Audit Details</h3>
                <p style={{ fontSize: '11px', color: 'var(--text-muted)', marginTop: '2px' }}>
                  ID: #{selectedOrder.id} • Purchased {new Date(selectedOrder.orderDate).toLocaleString('en-IN')}
                </p>
              </div>
              <button className="btn-icon" onClick={() => setSelectedOrder(null)}>
                Close
              </button>
            </div>

            <div className="modal-body" style={{ display: 'flex', flexDirection: 'column', gap: '20px' }}>
              
              {/* Timeline status indicator */}
              <div className="card" style={{ padding: '16px', background: 'var(--bg-tertiary)' }}>
                <h4 className="form-label" style={{ marginBottom: '12px' }}>FCM Delivery Status</h4>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                  <span className={`badge ${statusTones[selectedOrder.status]}`} style={{ fontSize: '13px', padding: '6px 14px', fontWeight: 'bold' }}>
                    {selectedOrder.status}
                  </span>
                  
                  {/* Status modifier dropdown in Modal */}
                  <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                    <span style={{ fontSize: '12px', color: 'var(--text-muted)' }}>Update:</span>
                    <select 
                      className="input-control select-control"
                      value={selectedOrder.status}
                      onChange={(e) => handleStatusChange(selectedOrder.id, e.target.value)}
                      style={{ padding: '8px 12px', fontSize: '12px', width: '160px' }}
                    >
                      {statusOptions.map(opt => (
                        <option key={opt.value} value={opt.value}>{opt.label}</option>
                      ))}
                    </select>
                  </div>
                </div>
                <div style={{ marginTop: '12px', fontSize: '11px', color: 'var(--text-muted)', display: 'flex', gap: '4px', alignItems: 'center' }}>
                  <HelpCircle size={12} />
                  <span>Modifying this state immediately broadcasts an FCM alert to the customer's device.</span>
                </div>
              </div>

              {/* Customer & Address Details */}
              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '20px' }}>
                <div>
                  <h4 className="form-label" style={{ borderBottom: '1px solid var(--border-color)', paddingBottom: '6px' }}>
                    Customer Contact
                  </h4>
                  <p style={{ fontWeight: '600', fontSize: '13px', marginTop: '8px' }}>{selectedOrder.customerName || 'Loyal Client'}</p>
                  <p style={{ fontSize: '12px', color: 'var(--text-secondary)', marginTop: '4px' }}>Phone: {selectedOrder.deliveryAddress?.phone || 'N/A'}</p>
                  <p style={{ fontSize: '12px', color: 'var(--text-secondary)' }}>Payment Option: {selectedOrder.paymentMethod}</p>
                  {selectedOrder.trackingId && (
                    <p style={{ fontSize: '12px', marginTop: '6px' }}>
                      <Clipboard size={12} style={{ display: 'inline', marginRight: '4px' }} />
                      Tracking ID: <span style={{ fontWeight: 'bold', fontFamily: 'monospace' }}>{selectedOrder.trackingId}</span>
                    </p>
                  )}
                </div>

                <div>
                  <h4 className="form-label" style={{ borderBottom: '1px solid var(--border-color)', paddingBottom: '6px' }}>
                    Fulfillment Destination
                  </h4>
                  {selectedOrder.deliveryAddress ? (
                    <div style={{ fontSize: '12px', color: 'var(--text-secondary)', marginTop: '8px', lineHeight: '1.4' }}>
                      <p>{selectedOrder.deliveryAddress.fullName}</p>
                      <p>{selectedOrder.deliveryAddress.streetAddress}</p>
                      <p>{selectedOrder.deliveryAddress.city}, {selectedOrder.deliveryAddress.state} - {selectedOrder.deliveryAddress.postalCode}</p>
                      <p>{selectedOrder.deliveryAddress.country}</p>
                    </div>
                  ) : (
                    <p style={{ fontSize: '12px', color: 'var(--text-muted)', marginTop: '8px' }}>No shipping address defined.</p>
                  )}
                </div>
              </div>

              {/* Items Ordered List */}
              <div>
                <h4 className="form-label" style={{ borderBottom: '1px solid var(--border-color)', paddingBottom: '6px', marginBottom: '10px' }}>
                  Ordered Items
                </h4>
                <div className="order-detail-items">
                  {selectedOrder.items?.map((item, index) => (
                    <div key={index} className="order-detail-item" style={{ display: 'flex', alignItems: 'center' }}>
                      <img 
                        src={item.product?.imageUrl || item.product?.imageUrls?.[0] || 'https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=80&q=80'} 
                        alt={item.product?.name} 
                        style={{ width: '40px', height: '40px', objectFit: 'cover', borderRadius: '4px', border: '1px solid var(--border-color)', marginRight: '12px' }}
                      />
                      <div style={{ flex: 1 }}>
                        <h5 style={{ fontSize: '13px', fontWeight: '600' }}>{item.product?.name}</h5>
                        <p style={{ fontSize: '11px', color: 'var(--text-muted)', marginTop: '2px' }}>
                          Size: {item.selectedSize} • Color: {item.selectedColor}
                        </p>
                      </div>
                      <div style={{ textAlign: 'right', fontSize: '13px' }}>
                        <div style={{ fontWeight: '600' }}>₹{item.product?.price} × {item.quantity}</div>
                        <div style={{ fontSize: '11px', color: 'var(--text-muted)' }}>Total: ₹{(item.product?.price * item.quantity).toFixed(2)}</div>
                      </div>
                    </div>
                  ))}
                </div>
              </div>

              {/* Financial calculations */}
              <div style={{ alignSelf: 'flex-end', width: '280px', display: 'flex', flexDirection: 'column', gap: '8px', borderTop: '1px solid var(--border-color)', paddingTop: '12px' }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '12px', color: 'var(--text-secondary)' }}>
                  <span>Cart Subtotal:</span>
                  <span>₹{selectedOrder.totalAmount?.toFixed(2)}</span>
                </div>
                {selectedOrder.discountAmount > 0 && (
                  <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '12px', color: 'var(--danger-color)' }}>
                    <span>Coupon Discount:</span>
                    <span>-₹{selectedOrder.discountAmount.toFixed(2)}</span>
                  </div>
                )}
                {selectedOrder.walletDeduction > 0 && (
                  <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '12px', color: 'var(--accent-color)' }}>
                    <span>Wallet Cashback Credits:</span>
                    <span>-₹{selectedOrder.walletDeduction.toFixed(2)}</span>
                  </div>
                )}
                <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '14px', fontWeight: '700', borderTop: '1px solid var(--border-color)', paddingTop: '8px', marginTop: '4px' }}>
                  <span>Grand Paid Total:</span>
                  <span>₹{selectedOrder.paidAmount?.toFixed(2)}</span>
                </div>
              </div>

            </div>

            <div className="modal-footer">
              <button className="btn btn-primary" onClick={() => setSelectedOrder(null)}>
                Dismiss
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
