import React, { useState } from 'react';
import { Tag, Plus, Trash2, ShieldAlert, Sparkles, History } from 'lucide-react';

export default function WalletCouponManagement({ 
  promos = [], 
  customers = [], 
  transactions = [],
  onAddPromo,
  onDeletePromo,
  onAdjustWallet
}) {
  // Coupon Form States
  const [code, setCode] = useState('');
  const [type, setType] = useState('percentage'); // percentage or flat
  const [value, setValue] = useState('');
  const [description, setDescription] = useState('');
  const [promoError, setPromoError] = useState('');

  // Wallet Form States
  const [selectedCustUid, setSelectedCustUid] = useState(customers[0]?.uid || '');
  const [walletType, setWalletType] = useState('cashback'); // cashback or points
  const [isCredit, setIsCredit] = useState(true); // true = credit, false = debit
  const [amount, setAmount] = useState('');
  const [walletSuccess, setWalletSuccess] = useState('');

  React.useEffect(() => {
    if (customers.length > 0 && (!selectedCustUid || !customers.some(c => c.uid === selectedCustUid))) {
      setSelectedCustUid(customers[0].uid);
    }
  }, [customers]);

  const handleAddPromoSubmit = (e) => {
    e.preventDefault();
    setPromoError('');

    if (promos.some(p => p.code.toUpperCase() === code.toUpperCase())) {
      setPromoError('Promo code already exists in catalog database.');
      return;
    }

    onAddPromo({
      code: code.toUpperCase().trim(),
      type,
      value: parseFloat(value),
      description
    });

    setCode('');
    setValue('');
    setDescription('');
  };

  const handleAdjustWalletSubmit = (e) => {
    e.preventDefault();
    setWalletSuccess('');

    const targetCustomer = customers.find(c => c.uid === selectedCustUid);
    if (!targetCustomer) return;

    const adjustAmt = parseFloat(amount);
    if (isNaN(adjustAmt) || adjustAmt <= 0) return;

    onAdjustWallet(selectedCustUid, adjustAmt, walletType, isCredit);
    
    setWalletSuccess(`Successfully processed ${isCredit ? 'credit' : 'debit'} of ${walletType === 'cashback' ? '₹' + adjustAmt : adjustAmt + ' points'} for ${targetCustomer.fullName}.`);
    setAmount('');

    setTimeout(() => setWalletSuccess(''), 3000);
  };

  return (
    <div className="animate-fade-in sub-panel-grid">
      
      {/* LEFT COLUMN: PROMO CODES */}
      <div className="flex-col" style={{ gap: '24px' }}>
        {/* Create Coupon Form Card */}
        <div className="card">
          <div className="card-header">
            <h3 className="card-title" style={{ display: 'flex', gap: '8px', alignItems: 'center' }}>
              <Tag size={18} color="var(--success-color)" /> Create Voucher Drop
            </h3>
          </div>

          {promoError && (
            <div className="badge badge-danger w-full" style={{ padding: '8px', borderRadius: '4px', marginBottom: '14px', textAlign: 'center' }}>
              {promoError}
            </div>
          )}

          <form onSubmit={handleAddPromoSubmit} style={{ display: 'flex', flexDirection: 'column', gap: '14px' }}>
            <div className="form-group">
              <label className="form-label">Promo Voucher Code</label>
              <input 
                type="text" 
                className="input-control w-full" 
                placeholder="e.g. FESTIVE20"
                value={code}
                onChange={(e) => setCode(e.target.value.toUpperCase())}
                required
              />
            </div>

            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '16px' }}>
              <div className="form-group">
                <label className="form-label">Discount Structure</label>
                <select 
                  className="input-control select-control w-full"
                  value={type}
                  onChange={(e) => setType(e.target.value)}
                >
                  <option value="percentage">Percentage Off (%)</option>
                  <option value="flat">Flat Rate Off (INR)</option>
                </select>
              </div>
              <div className="form-group">
                <label className="form-label">Value</label>
                <input 
                  type="number" 
                  className="input-control w-full"
                  placeholder={type === 'percentage' ? 'e.g. 15' : 'e.g. 300'}
                  value={value}
                  onChange={(e) => setValue(e.target.value)}
                  min="1"
                  required
                />
              </div>
            </div>

            <div className="form-group">
              <label className="form-label">Brief Description</label>
              <input 
                type="text" 
                className="input-control w-full"
                placeholder="e.g. 15% discount on checkout bags"
                value={description}
                onChange={(e) => setDescription(e.target.value)}
                required
              />
            </div>

            <button type="submit" className="btn btn-primary w-full" style={{ gap: '6px' }}>
              <Plus size={16} /> Publish Promo Voucher
            </button>
          </form>
        </div>

        {/* List Vouchers Card */}
        <div className="card">
          <div className="card-header">
            <h3 className="card-title">Active Shop Coupons</h3>
          </div>

          <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
            {promos.map((promo) => (
              <div 
                key={promo.id || promo.code} 
                style={{ 
                  display: 'flex', 
                  alignItems: 'center', 
                  justifyContent: 'space-between',
                  padding: '12px',
                  borderRadius: '8px',
                  border: '1px solid var(--border-color)',
                  background: 'var(--bg-secondary)'
                }}
              >
                <div>
                  <div style={{ display: 'flex', gap: '6px', alignItems: 'center' }}>
                    <span style={{ 
                      padding: '4px 8px', 
                      background: 'var(--bg-tertiary)', 
                      border: '1px dashed var(--success-color)',
                      fontFamily: 'monospace',
                      fontWeight: '700',
                      borderRadius: '4px',
                      color: 'var(--success-color)'
                    }}>
                      {promo.code}
                    </span>
                    <span style={{ fontSize: '12px', fontWeight: '700' }}>
                      {promo.type === 'percentage' ? `${promo.value}% Off` : `₹${promo.value} Flat`}
                    </span>
                  </div>
                  <p style={{ fontSize: '11px', color: 'var(--text-muted)', marginTop: '4px' }}>{promo.description}</p>
                </div>
                <button 
                  className="btn-icon" 
                  onClick={() => onDeletePromo(promo.id || promo.code)}
                  style={{ color: 'var(--danger-color)' }}
                  title="Revoke Promo"
                >
                  <Trash2 size={14} />
                </button>
              </div>
            ))}
            {promos.length === 0 && (
              <p style={{ textAlign: 'center', padding: '16px', color: 'var(--text-muted)', fontSize: '12px' }}>
                No active coupon drops available.
              </p>
            )}
          </div>
        </div>
      </div>

      {/* RIGHT COLUMN: WALLET SERVICES */}
      <div className="flex-col" style={{ gap: '24px' }}>
        {/* Wallet Adjustment Panel */}
        <div className="card">
          <div className="card-header">
            <h3 className="card-title" style={{ display: 'flex', gap: '8px', alignItems: 'center' }}>
              <Sparkles size={18} color="var(--accent-color)" /> Loyalty Wallet Concierge
            </h3>
          </div>

          {walletSuccess && (
            <div className="badge badge-success w-full" style={{ padding: '8px', borderRadius: '4px', marginBottom: '14px', textAlign: 'center', display: 'block' }}>
              {walletSuccess}
            </div>
          )}

          <form onSubmit={handleAdjustWalletSubmit} style={{ display: 'flex', flexDirection: 'column', gap: '14px' }}>
            <div className="form-group">
              <label className="form-label">Select Customer Target</label>
              <select
                className="input-control select-control w-full"
                value={selectedCustUid}
                onChange={(e) => setSelectedCustUid(e.target.value)}
                required
              >
                <option value="" disabled>Choose account...</option>
                {customers.map(c => (
                  <option key={c.uid} value={c.uid}>
                    {c.fullName} ({c.phone}) — Balance: ₹{c.walletCashback?.toFixed(2) || '0'}
                  </option>
                ))}
              </select>
            </div>

            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '16px' }}>
              <div className="form-group">
                <label className="form-label">Ledger Account Type</label>
                <select
                  className="input-control select-control w-full"
                  value={walletType}
                  onChange={(e) => setWalletType(e.target.value)}
                >
                  <option value="cashback">Aura Cashback (INR)</option>
                  <option value="points">Loyalty points (pts)</option>
                </select>
              </div>
              
              <div className="form-group">
                <label className="form-label">Action</label>
                <select
                  className="input-control select-control w-full"
                  value={isCredit ? "credit" : "debit"}
                  onChange={(e) => setIsCredit(e.target.value === "credit")}
                >
                  <option value="credit">Credit (+ Amount)</option>
                  <option value="debit">Debit (- Amount)</option>
                </select>
              </div>
            </div>

            <div className="form-group">
              <label className="form-label">Adjustment Amount</label>
              <input 
                type="number" 
                className="input-control w-full"
                placeholder={walletType === 'cashback' ? 'e.g. 100.00' : 'e.g. 500'}
                value={amount}
                onChange={(e) => setAmount(e.target.value)}
                min="0.01"
                step="any"
                required
              />
            </div>

            <button type="submit" className="btn btn-primary w-full" style={{ gap: '6px' }}>
              Process Wallet Entry
            </button>
          </form>
        </div>

        {/* Transaction History Ledger */}
        <div className="card">
          <div className="card-header">
            <h3 className="card-title" style={{ display: 'flex', gap: '8px', alignItems: 'center' }}>
              <History size={18} /> Concierge Ledger Audits
            </h3>
          </div>

          <div className="table-container" style={{ maxHeight: '300px', overflowY: 'auto' }}>
            <table className="admin-table" style={{ fontSize: '12px' }}>
              <thead>
                <tr>
                  <th>Client</th>
                  <th>Entry Detail</th>
                  <th style={{ textAlign: 'right' }}>Value Impact</th>
                </tr>
              </thead>
              <tbody>
                {transactions.map((tx, idx) => {
                  const client = customers.find(c => c.uid === tx.userId);
                  return (
                    <tr key={tx.id || idx}>
                      <td>
                        <span style={{ fontWeight: '600' }}>{client?.fullName || 'Loyal Client'}</span>
                        <p style={{ fontSize: '10px', color: 'var(--text-muted)' }}>
                          {new Date(tx.timestamp).toLocaleDateString('en-IN', { month: 'short', day: 'numeric' })}
                        </p>
                      </td>
                      <td style={{ color: 'var(--text-secondary)', fontSize: '11px', maxWidth: '160px', overflow: 'hidden', textOverflow: 'ellipsis' }}>
                        {tx.description}
                      </td>
                      <td style={{ textAlign: 'right', fontWeight: '700', color: tx.isCredit ? 'var(--success-color)' : 'var(--danger-color)' }}>
                        {tx.isCredit ? '+' : '-'}₹{tx.amount?.toFixed(2)}
                      </td>
                    </tr>
                  );
                })}
                {transactions.length === 0 && (
                  <tr>
                    <td colSpan="3" style={{ textAlign: 'center', padding: '16px', color: 'var(--text-muted)' }}>
                      No ledger actions processed yet.
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        </div>

      </div>

    </div>
  );
}
