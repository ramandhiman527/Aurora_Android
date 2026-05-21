import React, { useState } from 'react';
import { Truck, Search, Calendar, Landmark, Clipboard, CheckCircle2, AlertCircle, PlayCircle } from 'lucide-react';

export default function DeliveryTracking({ orders = [], onUpdateTracking }) {
  const [searchTerm, setSearchTerm] = useState('');
  const [activeTab, setActiveTab] = useState('active'); // active (preparing, packed, shipped, outForDelivery), completed (delivered)
  const [selectedOrderId, setSelectedOrderId] = useState(orders[0]?.id || null);
  const [trackingId, setTrackingId] = useState('');
  const [deliveryPartner, setDeliveryPartner] = useState('Aura Express');
  const [estimatedDelivery, setEstimatedDelivery] = useState('');
  const [shippingStatus, setShippingStatus] = useState('preparing');
  const [successMsg, setSuccessMsg] = useState('');

  // Find active selected order details
  const selectedOrder = orders.find(o => o.id === selectedOrderId);

  // Sync state when selected order changes
  React.useEffect(() => {
    if (selectedOrder) {
      setTrackingId(selectedOrder.trackingId || '');
      setDeliveryPartner(selectedOrder.deliveryPartner || 'Aura Express');
      
      // format date to YYYY-MM-DD
      if (selectedOrder.estimatedDelivery) {
        const d = new Date(selectedOrder.estimatedDelivery);
        const formatted = d.toISOString().split('T')[0];
        setEstimatedDelivery(formatted);
      } else {
        // default 3 days from order date
        const d = new Date(selectedOrder.orderDate);
        d.setDate(d.getDate() + 3);
        setEstimatedDelivery(d.toISOString().split('T')[0]);
      }
      setShippingStatus(selectedOrder.status || 'preparing');
    }
  }, [selectedOrderId, orders]);

  // Filter orders
  const filteredOrders = orders.filter(order => {
    const matchesSearch = 
      order.id?.toLowerCase().includes(searchTerm.toLowerCase()) || 
      order.customerName?.toLowerCase().includes(searchTerm.toLowerCase()) ||
      order.trackingId?.toLowerCase().includes(searchTerm.toLowerCase());

    const isCompleted = order.status === 'delivered';
    const matchesTab = activeTab === 'completed' ? isCompleted : !isCompleted;

    return matchesSearch && matchesTab;
  });

  // Set default selected order if the current one is filtered out
  React.useEffect(() => {
    if (filteredOrders.length > 0 && (!selectedOrderId || !filteredOrders.find(o => o.id === selectedOrderId))) {
      setSelectedOrderId(filteredOrders[0].id);
    }
  }, [activeTab, searchTerm]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!selectedOrderId) return;

    try {
      await onUpdateTracking(selectedOrderId, {
        trackingId,
        deliveryPartner,
        estimatedDelivery: estimatedDelivery ? new Date(estimatedDelivery).toISOString() : '',
        status: shippingStatus
      });
      
      setSuccessMsg('Logistics dispatch updated successfully!');
      setTimeout(() => setSuccessMsg(''), 3000);
    } catch (err) {
      console.error(err);
    }
  };

  const getStatusStepIndex = (status) => {
    switch (status) {
      case 'preparing': return 0;
      case 'packed': return 1;
      case 'shipped': return 2;
      case 'outForDelivery': return 3;
      case 'delivered': return 4;
      default: return 0;
    }
  };

  const currentStep = getStatusStepIndex(shippingStatus);
  const steps = [
    { label: 'Preparing', desc: 'Sourcing item' },
    { label: 'Packed', desc: 'Secure box' },
    { label: 'Shipped', desc: 'In transit' },
    { label: 'Out for Delivery', desc: 'City courier' },
    { label: 'Delivered', desc: 'Handed over' }
  ];

  return (
    <div className="animate-fade-in">
      <div className="header">
        <div className="header-title">
          <h1>Delivery Tracking & Logistics Center</h1>
          <p>Assign courier details, monitor package flow, and update estimated arrival dates</p>
        </div>
      </div>

      {/* Tabs and Search */}
      <div className="header-controls" style={{ justifyContent: 'space-between', marginBottom: '24px', width: '100%' }}>
        <div style={{ position: 'relative', flex: 1, maxWidth: '400px' }}>
          <Search size={16} style={{ position: 'absolute', left: '12px', top: '13px', color: 'var(--text-muted)' }} />
          <input 
            type="text" 
            className="input-control w-full" 
            placeholder="Search package IDs, clients, tracking..." 
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            style={{ paddingLeft: '40px' }}
          />
        </div>

        <div className="pills-container">
          <span className={`pill ${activeTab === 'active' ? 'active' : ''}`} onClick={() => setActiveTab('active')}>Active Shipments</span>
          <span className={`pill ${activeTab === 'completed' ? 'active' : ''}`} onClick={() => setActiveTab('completed')}>Completed Deliveries</span>
        </div>
      </div>

      <div className="sub-panel-grid" style={{ gridTemplateColumns: '1fr 1.3fr' }}>
        {/* Left Side: Orders list */}
        <div className="card" style={{ padding: '20px' }}>
          <div className="card-header" style={{ marginBottom: '16px' }}>
            <h3 className="card-title">Packages ({filteredOrders.length})</h3>
          </div>

          <div style={{ display: 'flex', flexDirection: 'column', gap: '12px', maxHeight: '550px', overflowY: 'auto', paddingRight: '4px' }}>
            {filteredOrders.length === 0 ? (
              <div style={{ textAlign: 'center', padding: '40px 0', color: 'var(--text-muted)' }}>
                <Truck size={32} style={{ marginBottom: '12px', strokeWidth: '1.5' }} />
                <p>No shipments matching this filter</p>
              </div>
            ) : (
              filteredOrders.map((order) => {
                const isSelected = order.id === selectedOrderId;
                const statusBadge = 
                  order.status === 'delivered' ? 'badge-success' :
                  order.status === 'outForDelivery' ? 'badge-info' :
                  order.status === 'shipped' ? 'badge-warning' : 'badge-secondary';

                return (
                  <div
                    key={order.id}
                    onClick={() => setSelectedOrderId(order.id)}
                    style={{
                      border: '1px solid var(--border-color)',
                      borderRadius: 'var(--border-radius-sm)',
                      padding: '14px',
                      cursor: 'pointer',
                      backgroundColor: isSelected ? 'rgba(0, 113, 227, 0.05)' : 'var(--bg-tertiary)',
                      borderColor: isSelected ? 'var(--accent-color)' : 'var(--border-color)',
                      transition: 'all 0.2s ease',
                      display: 'flex',
                      justifyContent: 'space-between',
                      alignItems: 'center'
                    }}
                  >
                    <div>
                      <div style={{ fontWeight: '700', fontSize: '13.5px', color: 'var(--text-primary)' }}>
                        #{order.id}
                      </div>
                      <div style={{ fontSize: '12px', color: 'var(--text-secondary)', marginTop: '2px' }}>
                        {order.customerName}
                      </div>
                      {order.trackingId ? (
                        <div style={{ fontSize: '11px', color: 'var(--text-muted)', marginTop: '4px', fontFamily: 'monospace' }}>
                          {order.trackingId}
                        </div>
                      ) : (
                        <div style={{ fontSize: '11px', color: 'var(--danger-color)', marginTop: '4px', fontWeight: '500' }}>
                          No tracking assigned
                        </div>
                      )}
                    </div>

                    <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'flex-end', gap: '6px' }}>
                      <span className={`badge ${statusBadge}`} style={{ fontSize: '10.5px' }}>
                        {order.status}
                      </span>
                      <span style={{ fontSize: '11px', color: 'var(--text-muted)' }}>
                        ₹{order.paidAmount?.toFixed(2)}
                      </span>
                    </div>
                  </div>
                );
              })
            )}
          </div>
        </div>

        {/* Right Side: Tracking Manager Card */}
        {selectedOrder ? (
          <div className="card">
            <div className="card-header" style={{ borderBottom: '1px solid var(--border-color)', paddingBottom: '16px', marginBottom: '20px' }}>
              <div>
                <h3 className="card-title">Logistics Manager</h3>
                <p style={{ fontSize: '12px', color: 'var(--text-muted)', marginTop: '2px' }}>
                  Assign and publish real-time tracking information for Order #{selectedOrder.id}
                </p>
              </div>
              <span className="badge badge-info" style={{ fontSize: '12px', padding: '6px 12px' }}>
                {selectedOrder.paymentMethod}
              </span>
            </div>

            {successMsg && (
              <div className="badge badge-success" style={{ width: '100%', padding: '12px', borderRadius: '8px', marginBottom: '20px', display: 'flex', gap: '8px', fontSize: '13px' }}>
                <CheckCircle2 size={16} />
                {successMsg}
              </div>
            )}

            {/* Courier timeline visualization */}
            <div style={{ marginBottom: '32px' }}>
              <h4 className="form-label" style={{ marginBottom: '16px' }}>Live Package Tracking Flow</h4>
              <div style={{ display: 'flex', justifyContent: 'space-between', position: 'relative', width: '100%', padding: '0 10px' }}>
                
                {/* Horizontal connector line */}
                <div style={{
                  position: 'absolute',
                  top: '12px',
                  left: '30px',
                  right: '30px',
                  height: '2px',
                  backgroundColor: 'var(--border-color)',
                  zIndex: '1'
                }}></div>
                
                {/* Visual filled path */}
                <div style={{
                  position: 'absolute',
                  top: '12px',
                  left: '30px',
                  width: `${(currentStep / 4) * 85}%`,
                  height: '2px',
                  backgroundColor: 'var(--accent-color)',
                  zIndex: '1',
                  transition: 'width 0.3s ease'
                }}></div>

                {steps.map((step, idx) => {
                  const isActive = idx <= currentStep;
                  const isCurrent = idx === currentStep;
                  
                  return (
                    <div 
                      key={idx} 
                      style={{ 
                        display: 'flex', 
                        flexDirection: 'column', 
                        alignItems: 'center', 
                        zIndex: '2',
                        width: '60px',
                        textAlign: 'center'
                      }}
                    >
                      <div 
                        style={{
                          width: '26px',
                          height: '26px',
                          borderRadius: '50%',
                          backgroundColor: isCurrent ? 'var(--accent-color)' : (isActive ? 'var(--accent-color)' : 'var(--bg-tertiary)'),
                          border: `2px solid ${isCurrent ? 'var(--accent-color)' : (isActive ? 'var(--accent-color)' : 'var(--border-color)')}`,
                          display: 'flex',
                          alignItems: 'center',
                          justifyContent: 'center',
                          color: isActive ? 'white' : 'var(--text-muted)',
                          fontSize: '11px',
                          fontWeight: '700',
                          boxShadow: isCurrent ? '0 0 10px rgba(0, 113, 227, 0.4)' : 'none',
                          transition: 'all 0.3s ease'
                        }}
                      >
                        {isActive ? '✓' : idx + 1}
                      </div>
                      <span style={{ fontSize: '10.5px', fontWeight: isActive ? '700' : '500', color: isActive ? 'var(--text-primary)' : 'var(--text-muted)', marginTop: '8px', display: 'block', lineHeight: '1.2' }}>
                        {step.label}
                      </span>
                    </div>
                  );
                })}
              </div>
            </div>

            {/* Input Form */}
            <form onSubmit={handleSubmit}>
              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '20px', marginBottom: '20px' }}>
                <div className="form-group">
                  <label className="form-label">Tracking ID / AWB Number</label>
                  <input
                    type="text"
                    className="input-control"
                    placeholder="e.g. TRK-410931-A"
                    value={trackingId}
                    onChange={(e) => setTrackingId(e.target.value)}
                    required
                  />
                </div>

                <div className="form-group">
                  <label className="form-label">Logistics Logistics Partner</label>
                  <select
                    className="input-control select-control"
                    value={deliveryPartner}
                    onChange={(e) => setDeliveryPartner(e.target.value)}
                  >
                    <option value="Aura Express">Aura Express (Internal Concierge)</option>
                    <option value="Delhivery Courier">Delhivery</option>
                    <option value="Blue Dart Express">Blue Dart</option>
                    <option value="FedEx Premium">FedEx Priority</option>
                    <option value="DHL Worldwide">DHL Logistics</option>
                  </select>
                </div>
              </div>

              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '20px', marginBottom: '20px' }}>
                <div className="form-group">
                  <label className="form-label">Estimated Delivery Date</label>
                  <input
                    type="date"
                    className="input-control"
                    value={estimatedDelivery}
                    onChange={(e) => setEstimatedDelivery(e.target.value)}
                    required
                  />
                </div>

                <div className="form-group">
                  <label className="form-label">Update Transit Stage</label>
                  <select
                    className="input-control select-control"
                    value={shippingStatus}
                    onChange={(e) => setShippingStatus(e.target.value)}
                  >
                    <option value="preparing">1. Preparing Package</option>
                    <option value="packed">2. Securely Packed</option>
                    <option value="shipped">3. Shipped Out (In Transit)</option>
                    <option value="outForDelivery">4. Out for Delivery</option>
                    <option value="delivered">5. Delivered Successfully</option>
                  </select>
                </div>
              </div>

              {/* Destination Address Reader */}
              <div 
                style={{ 
                  backgroundColor: 'var(--bg-tertiary)', 
                  border: '1px solid var(--border-color)', 
                  borderRadius: 'var(--border-radius-sm)', 
                  padding: '16px',
                  marginBottom: '24px'
                }}
              >
                <h4 className="form-label" style={{ borderBottom: '1px solid var(--border-color)', paddingBottom: '6px', marginBottom: '8px' }}>
                  Fulfillment Destination
                </h4>
                {selectedOrder.deliveryAddress ? (
                  <div style={{ fontSize: '13px', color: 'var(--text-secondary)', lineHeight: '1.4' }}>
                    <p style={{ fontWeight: '600', color: 'var(--text-primary)' }}>{selectedOrder.deliveryAddress.fullName}</p>
                    <p>{selectedOrder.deliveryAddress.streetAddress}</p>
                    <p>{selectedOrder.deliveryAddress.city}, {selectedOrder.deliveryAddress.state} - {selectedOrder.deliveryAddress.postalCode}</p>
                    <p>{selectedOrder.deliveryAddress.country} • Phone: {selectedOrder.deliveryAddress.phone}</p>
                  </div>
                ) : (
                  <p style={{ fontSize: '12px', color: 'var(--text-muted)' }}>No shipping address defined.</p>
                )}
              </div>

              <div style={{ display: 'flex', gap: '12px', justifyContent: 'flex-end' }}>
                <button type="submit" className="btn btn-primary" style={{ padding: '12px 24px' }}>
                  <Truck size={16} />
                  Save Logistics Details
                </button>
              </div>
            </form>
          </div>
        ) : (
          <div className="card" style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', minHeight: '300px' }}>
            <AlertCircle size={40} style={{ color: 'var(--text-muted)', marginBottom: '16px', strokeWidth: '1.5' }} />
            <h3 style={{ color: 'var(--text-primary)', fontSize: '16px', fontWeight: '600' }}>No Package Selected</h3>
            <p style={{ color: 'var(--text-muted)', fontSize: '13px', marginTop: '4px' }}>Select an order from the list to manage shipment data</p>
          </div>
        )}
      </div>
    </div>
  );
}
