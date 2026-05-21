import React, { useState } from 'react';
import { Search, Eye, Award } from 'lucide-react';

export default function CustomerManagement({ customers = [], onUpdateRank }) {
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedCustomer, setSelectedCustomer] = useState(null);

  // Filter
  const filteredCustomers = customers.filter(customer => {
    return (
      customer.fullName?.toLowerCase().includes(searchTerm.toLowerCase()) ||
      customer.phone?.includes(searchTerm) ||
      customer.email?.toLowerCase().includes(searchTerm.toLowerCase()) ||
      customer.customerRank?.toLowerCase().includes(searchTerm.toLowerCase())
    );
  });

  const getInitials = (name) => {
    if (!name) return '??';
    return name.split(' ').map(n => n[0]).slice(0, 2).join('').toUpperCase();
  };

  const getVipClass = (rank) => {
    if (rank === 'gold') return 'vip-gold';
    if (rank === 'platinum') return 'vip-platinum';
    return '';
  };

  const rankOptions = [
    { value: 'bronze', label: '🥉 Bronze Standard' },
    { value: 'silver', label: '🥈 Silver Standard' },
    { value: 'gold', label: '🥇 Gold Class' },
    { value: 'platinum', label: '👑 Platinum Class' }
  ];

  return (
    <div className="animate-fade-in">
      <div className="header-controls" style={{ marginBottom: '24px', maxWidth: '400px' }}>
        <div style={{ position: 'relative', width: '100%' }}>
          <Search size={16} style={{ position: 'absolute', left: '12px', top: '13px', color: 'var(--text-muted)' }} />
          <input 
            type="text" 
            className="input-control w-full" 
            placeholder="Search customers by name, phone, or rank..." 
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            style={{ paddingLeft: '40px' }}
          />
        </div>
      </div>

      {/* Customer Registry Card */}
      <div className="card">
        <div className="card-header">
          <h3 className="card-title">Registered Customer Base ({filteredCustomers.length} Records)</h3>
        </div>

        <div className="table-container">
          <table className="admin-table">
            <thead>
              <tr>
                <th>Profile</th>
                <th>Full Name</th>
                <th>Phone Number</th>
                <th>Email Address</th>
                <th>Loyalty Rank</th>
                <th>Cashback Balance</th>
                <th>Points Balance</th>
                <th>Signed Up</th>
                <th style={{ textAlign: 'right' }}>Actions</th>
              </tr>
            </thead>
            <tbody>
              {filteredCustomers.map((cust) => (
                <tr key={cust.uid}>
                  <td>
                    <div className={`avatar-circle ${getVipClass(cust.customerRank)}`}>
                      {getInitials(cust.fullName)}
                    </div>
                  </td>
                  <td style={{ fontWeight: '600' }}>{cust.fullName}</td>
                  <td>{cust.phone}</td>
                  <td style={{ color: 'var(--text-secondary)' }}>{cust.email || 'N/A'}</td>
                  <td>
                    <select 
                      className="input-control"
                      value={cust.customerRank || 'bronze'}
                      onChange={(e) => onUpdateRank(cust.uid, e.target.value)}
                      style={{ padding: '6px 10px', fontSize: '12px', width: '150px' }}
                    >
                      {rankOptions.map(opt => (
                        <option key={opt.value} value={opt.value}>{opt.label}</option>
                      ))}
                    </select>
                  </td>
                  <td style={{ fontWeight: '600' }}>
                    ₹{cust.walletCashback !== undefined ? cust.walletCashback.toFixed(2) : '0.00'}
                  </td>
                  <td style={{ fontWeight: '600', color: 'var(--text-secondary)' }}>
                    {cust.walletPoints !== undefined ? cust.walletPoints.toLocaleString('en-IN') : '0'} pts
                  </td>
                  <td>
                    <span style={{ fontSize: '11px', color: 'var(--text-muted)' }}>
                      {cust.createdAt ? new Date(cust.createdAt).toLocaleDateString('en-IN') : 'N/A'}
                    </span>
                  </td>
                  <td>
                    <div style={{ display: 'flex', gap: '8px', justifyContent: 'flex-end' }}>
                      <button className="btn btn-secondary small-btn" onClick={() => setSelectedCustomer(cust)} style={{ padding: '6px 12px', gap: '4px' }}>
                        <Eye size={12} /> Inspect
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
              {filteredCustomers.length === 0 && (
                <tr>
                  <td colSpan="9" style={{ textAlign: 'center', padding: '36px 0', color: 'var(--text-muted)' }}>
                    No customer records matched your query.
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      </div>

      {/* CUSTOMER INSPECTOR MODAL */}
      {selectedCustomer && (
        <div className="modal-overlay">
          <div className="modal-content" style={{ maxWidth: '520px' }}>
            <div className="modal-header">
              <h3>Customer Profile Inspector</h3>
              <button className="btn-icon" onClick={() => setSelectedCustomer(null)}>
                Close
              </button>
            </div>
            
            <div className="modal-body" style={{ display: 'flex', flexDirection: 'column', gap: '20px' }}>
              {/* Header profile details */}
              <div style={{ display: 'flex', alignItems: 'center', gap: '16px' }}>
                <div 
                  className={`avatar-circle ${getVipClass(selectedCustomer.customerRank)}`} 
                  style={{ width: '60px', height: '60px', fontSize: '20px', borderRadius: '50%' }}
                >
                  {getInitials(selectedCustomer.fullName)}
                </div>
                <div>
                  <h2 style={{ fontSize: '18px', fontWeight: '700' }}>{selectedCustomer.fullName}</h2>
                  <p style={{ fontSize: '12px', color: 'var(--text-muted)', marginTop: '2px' }}>
                    Database UID: {selectedCustomer.uid}
                  </p>
                </div>
              </div>

              {/* Status details */}
              <div className="card" style={{ padding: '16px', background: 'var(--bg-tertiary)' }}>
                <h4 className="form-label" style={{ marginBottom: '8px' }}>Loyalty Classification</h4>
                <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
                  <Award size={18} color="var(--accent-color)" />
                  <span style={{ fontWeight: '700', textTransform: 'uppercase', fontSize: '14px' }}>
                    {selectedCustomer.customerRank} Rank Standard
                  </span>
                </div>
              </div>

              {/* Contact info grid */}
              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '16px' }}>
                <div>
                  <span className="form-label" style={{ fontSize: '11px' }}>Primary Phone</span>
                  <p style={{ fontSize: '13px', fontWeight: '600', marginTop: '4px' }}>{selectedCustomer.phone}</p>
                </div>
                <div>
                  <span className="form-label" style={{ fontSize: '11px' }}>Email Address</span>
                  <p style={{ fontSize: '13px', fontWeight: '600', marginTop: '4px' }}>{selectedCustomer.email || 'N/A'}</p>
                </div>
                <div>
                  <span className="form-label" style={{ fontSize: '11px' }}>Loyalty Wallet Cashback</span>
                  <p style={{ fontSize: '14px', fontWeight: '700', color: 'var(--success-color)', marginTop: '4px' }}>
                    ₹{selectedCustomer.walletCashback?.toFixed(2) || '0.00'}
                  </p>
                </div>
                <div>
                  <span className="form-label" style={{ fontSize: '11px' }}>Loyalty Reward Points</span>
                  <p style={{ fontSize: '14px', fontWeight: '700', color: 'var(--text-primary)', marginTop: '4px' }}>
                    {selectedCustomer.walletPoints?.toLocaleString('en-IN') || '0'} pts
                  </p>
                </div>
              </div>

              {/* Address detail simulation */}
              <div>
                <span className="form-label" style={{ borderBottom: '1px solid var(--border-color)', paddingBottom: '4px', display: 'block' }}>
                  Stored Address Book (Estimated)
                </span>
                <div style={{ fontSize: '12px', color: 'var(--text-secondary)', marginTop: '8px', lineHeight: '1.4' }}>
                  <p style={{ fontWeight: '600', color: 'var(--text-primary)' }}>Default Location:</p>
                  <p>Flat 402, Royal Palms, Sector 56</p>
                  <p>Gurugram, Haryana - 122011, India</p>
                </div>
              </div>
            </div>

            <div className="modal-footer">
              <button className="btn btn-primary" onClick={() => setSelectedCustomer(null)}>
                Dismiss Inspector
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
