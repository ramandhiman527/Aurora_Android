import React, { useState } from 'react';
import { Search, Plus, Edit2, Trash2, X, AlertCircle } from 'lucide-react';

export default function ProductManagement({ products = [], categories = [], onAdd, onUpdate, onDelete }) {
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedCategoryFilter, setSelectedCategoryFilter] = useState('');
  
  // Modal states
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingProduct, setEditingProduct] = useState(null); // null = adding, object = editing
  const [confirmDeleteId, setConfirmDeleteId] = useState(null);

  // Form states
  const [name, setName] = useState('');
  const [description, setDescription] = useState('');
  const [price, setPrice] = useState('');
  const [originalPrice, setOriginalPrice] = useState('');
  const [categoryId, setCategoryId] = useState('cat1');
  const [imageUrls, setImageUrls] = useState(['']);
  const [availableSizes, setAvailableSizes] = useState('');
  const [availableColors, setAvailableColors] = useState('');
  const [stockCount, setStockCount] = useState(10);
  const [isFeatured, setIsFeatured] = useState(false);
  const [isTrending, setIsTrending] = useState(false);
  const [isNewArrival, setIsNewArrival] = useState(false);
  const [isLimitedEdition, setIsLimitedEdition] = useState(false);

  const resetForm = () => {
    setName('');
    setDescription('');
    setPrice('');
    setOriginalPrice('');
    setCategoryId(categories[0]?.id || 'cat1');
    setImageUrls(['']);
    setAvailableSizes('');
    setAvailableColors('');
    setStockCount(10);
    setIsFeatured(false);
    setIsTrending(false);
    setIsNewArrival(false);
    setIsLimitedEdition(false);
    setEditingProduct(null);
  };

  const openAddModal = () => {
    resetForm();
    setIsModalOpen(true);
  };

  const openEditModal = (product) => {
    setEditingProduct(product);
    setName(product.name || '');
    setDescription(product.description || '');
    setPrice(product.price || '');
    setOriginalPrice(product.originalPrice || '');
    setCategoryId(product.categoryId || 'cat1');
    setImageUrls(product.imageUrls && product.imageUrls.length > 0 ? [...product.imageUrls] : ['']);
    setAvailableSizes(product.availableSizes?.join(', ') || '');
    setAvailableColors(product.availableColors?.join(', ') || '');
    setStockCount(product.stockCount || 0);
    setIsFeatured(product.isFeatured || false);
    setIsTrending(product.isTrending || false);
    setIsNewArrival(product.isNewArrival || false);
    setIsLimitedEdition(product.isLimitedEdition || false);
    setIsModalOpen(true);
  };

  const handleImageUrlChange = (index, val) => {
    const updated = [...imageUrls];
    updated[index] = val;
    setImageUrls(updated);
  };

  const addImageField = () => {
    setImageUrls([...imageUrls, '']);
  };

  const removeImageField = (index) => {
    if (imageUrls.length <= 1) return;
    const updated = imageUrls.filter((_, idx) => idx !== index);
    setImageUrls(updated);
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    
    const productPayload = {
      name,
      description,
      price: parseFloat(price),
      originalPrice: originalPrice ? parseFloat(originalPrice) : null,
      categoryId,
      imageUrls: imageUrls.filter(url => url.trim() !== ''),
      availableSizes: availableSizes.split(',').map(s => s.trim()).filter(s => s !== ''),
      availableColors: availableColors.split(',').map(c => c.trim()).filter(c => c !== ''),
      stockCount: parseInt(stockCount),
      isFeatured,
      isTrending,
      isNewArrival,
      isLimitedEdition
    };

    if (editingProduct) {
      onUpdate(editingProduct.id, productPayload);
    } else {
      onAdd(productPayload);
    }
    
    setIsModalOpen(false);
    resetForm();
  };

  const handleDeleteClick = (id) => {
    setConfirmDeleteId(id);
  };

  const handleConfirmDelete = () => {
    onDelete(confirmDeleteId);
    setConfirmDeleteId(null);
  };

  // Filter products
  const filteredProducts = products.filter(p => {
    const matchesSearch = p.name?.toLowerCase().includes(searchTerm.toLowerCase()) || 
                          p.description?.toLowerCase().includes(searchTerm.toLowerCase()) ||
                          p.id?.toLowerCase().includes(searchTerm.toLowerCase());
    
    const matchesCat = selectedCategoryFilter ? p.categoryId === selectedCategoryFilter : true;
    return matchesSearch && matchesCat;
  });

  return (
    <div className="animate-fade-in">
      <div className="header-controls" style={{ justifyContent: 'space-between', marginBottom: '24px', width: '100%' }}>
        <div style={{ display: 'flex', gap: '12px', flex: 1, maxWidth: '500px' }}>
          <div style={{ position: 'relative', flex: 1 }}>
            <Search size={16} style={{ position: 'absolute', left: '12px', top: '13px', color: 'var(--text-muted)' }} />
            <input 
              type="text" 
              className="input-control w-full" 
              placeholder="Search product inventory by name or SKU ID..." 
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              style={{ paddingLeft: '40px', paddingRight: '12px' }}
            />
          </div>
          <select 
            className="input-control select-control" 
            value={selectedCategoryFilter}
            onChange={(e) => setSelectedCategoryFilter(e.target.value)}
            style={{ width: '180px' }}
          >
            <option value="">All Categories</option>
            {categories.map(cat => (
              <option key={cat.id} value={cat.id}>{cat.name}</option>
            ))}
          </select>
        </div>

        <button className="btn btn-primary" onClick={openAddModal}>
          <Plus size={16} /> Add New Drop
        </button>
      </div>

      {/* Products Catalog Table Card */}
      <div className="card">
        <div className="card-header">
          <h3 className="card-title">Inventory Catalog ({filteredProducts.length} Items)</h3>
          {products.some(p => p.stockCount <= 12) && (
            <span className="badge badge-warning" style={{ gap: '4px' }}>
              <AlertCircle size={12} /> Low Stock Warning Active
            </span>
          )}
        </div>

        <div className="table-container">
          <table className="admin-table">
            <thead>
              <tr>
                <th>Product ID</th>
                <th>Drop Preview</th>
                <th>Product Name</th>
                <th>Category</th>
                <th>Price Details</th>
                <th>Inventory Stock</th>
                <th>Tags</th>
                <th style={{ textAlign: 'right' }}>Actions</th>
              </tr>
            </thead>
            <tbody>
              {filteredProducts.map((product) => {
                const categoryObj = categories.find(c => c.id === product.categoryId);
                
                // Inventory level color coding
                let stockBadgeClass = 'badge-success';
                if (product.stockCount <= 5) {
                  stockBadgeClass = 'badge-danger animate-pulse-slow';
                } else if (product.stockCount <= 12) {
                  stockBadgeClass = 'badge-warning';
                }

                return (
                  <tr key={product.id}>
                    <td style={{ fontFamily: 'monospace', fontSize: '11px', color: 'var(--text-muted)' }}>
                      {product.id}
                    </td>
                    <td>
                      <img 
                        src={product.imageUrls?.[0] || 'https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=100&q=80'} 
                        alt={product.name} 
                        style={{ width: '42px', height: '42px', objectFit: 'cover', borderRadius: '6px', border: '1px solid var(--border-color)' }}
                      />
                    </td>
                    <td>
                      <div style={{ fontWeight: '600', fontSize: '14px' }}>{product.name}</div>
                      <div style={{ fontSize: '11px', color: 'var(--text-muted)', maxWidth: '240px', overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                        {product.description}
                      </div>
                    </td>
                    <td>
                      <span className="badge badge-info" style={{ backgroundColor: 'var(--bg-tertiary)', color: 'var(--text-secondary)' }}>
                        {categoryObj?.name || 'Uncategorized'}
                      </span>
                    </td>
                    <td>
                      <div style={{ fontWeight: '600' }}>₹{product.price?.toFixed(2)}</div>
                      {product.originalPrice && (
                        <div style={{ fontSize: '11px', textDecoration: 'line-through', color: 'var(--text-muted)' }}>
                          ₹{product.originalPrice.toFixed(2)}
                        </div>
                      )}
                    </td>
                    <td>
                      <span className={`badge ${stockBadgeClass}`} style={{ fontWeight: '700' }}>
                        {product.stockCount} units
                      </span>
                    </td>
                    <td>
                      <div className="flex-row-wrap" style={{ gap: '4px' }}>
                        {product.isFeatured && <span className="badge" style={{ fontSize: '9px', background: 'rgba(0,113,227,0.1)', color: 'var(--accent-color)' }}>Featured</span>}
                        {product.isTrending && <span className="badge" style={{ fontSize: '9px', background: 'rgba(255,159,10,0.1)', color: 'var(--warning-color)' }}>Trending</span>}
                        {product.isNewArrival && <span className="badge" style={{ fontSize: '9px', background: 'rgba(52,199,89,0.1)', color: 'var(--success-color)' }}>New</span>}
                        {product.isLimitedEdition && <span className="badge" style={{ fontSize: '9px', background: 'rgba(175,82,222,0.1)', color: '#af52de' }}>Limited</span>}
                      </div>
                    </td>
                    <td>
                      <div style={{ display: 'flex', gap: '8px', justifyContent: 'flex-end' }}>
                        <button className="btn-icon" onClick={() => openEditModal(product)} title="Edit Details">
                          <Edit2 size={14} />
                        </button>
                        <button className="btn-icon" onClick={() => handleDeleteClick(product.id)} title="Delete Product" style={{ color: 'var(--danger-color)' }}>
                          <Trash2 size={14} />
                        </button>
                      </div>
                    </td>
                  </tr>
                );
              })}
              {filteredProducts.length === 0 && (
                <tr>
                  <td colSpan="8" style={{ textAlign: 'center', padding: '36px 0', color: 'var(--text-muted)' }}>
                    No products matching search criteria.
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      </div>

      {/* ADD / EDIT PRODUCT MODAL */}
      {isModalOpen && (
        <div className="modal-overlay">
          <div className="modal-content">
            <div className="modal-header">
              <h3>{editingProduct ? 'Modify Product Specifications' : 'Introduce New Catalog Item'}</h3>
              <button className="btn-icon" onClick={() => setIsModalOpen(false)}>
                <X size={18} />
              </button>
            </div>
            
            <form onSubmit={handleSubmit}>
              <div className="modal-body">
                <div className="form-group">
                  <label className="form-label">Product Title</label>
                  <input 
                    type="text" 
                    className="input-control w-full" 
                    value={name} 
                    onChange={(e) => setName(e.target.value)} 
                    placeholder="e.g. HMD Crest Max 5G"
                    required 
                  />
                </div>

                <div className="form-group">
                  <label className="form-label">Specification Description</label>
                  <textarea 
                    className="input-control w-full" 
                    rows="3" 
                    value={description} 
                    onChange={(e) => setDescription(e.target.value)} 
                    placeholder="Provide design elements, specifications, fabric/display details..."
                    style={{ resize: 'vertical' }}
                    required
                  />
                </div>

                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '16px' }}>
                  <div className="form-group">
                    <label className="form-label">Price (INR)</label>
                    <input 
                      type="number" 
                      step="0.01" 
                      className="input-control w-full" 
                      value={price} 
                      onChange={(e) => setPrice(e.target.value)} 
                      placeholder="14999.00"
                      required 
                    />
                  </div>
                  <div className="form-group">
                    <label className="form-label">Original Price (Strikeoff)</label>
                    <input 
                      type="number" 
                      step="0.01" 
                      className="input-control w-full" 
                      value={originalPrice} 
                      onChange={(e) => setOriginalPrice(e.target.value)} 
                      placeholder="e.g. 16999.00 (optional)"
                    />
                  </div>
                </div>

                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '16px' }}>
                  <div className="form-group">
                    <label className="form-label">Product Category</label>
                    <select 
                      className="input-control select-control w-full" 
                      value={categoryId} 
                      onChange={(e) => setCategoryId(e.target.value)}
                    >
                      {categories.map(cat => (
                        <option key={cat.id} value={cat.id}>{cat.name}</option>
                      ))}
                    </select>
                  </div>
                  <div className="form-group">
                    <label className="form-label">Inventory SKU Stock</label>
                    <input 
                      type="number" 
                      className="input-control w-full" 
                      value={stockCount} 
                      onChange={(e) => setStockCount(e.target.value)} 
                      required 
                    />
                  </div>
                </div>

                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '16px' }}>
                  <div className="form-group">
                    <label className="form-label">Available Sizes (Comma-separated)</label>
                    <input 
                      type="text" 
                      className="input-control w-full" 
                      value={availableSizes} 
                      onChange={(e) => setAvailableSizes(e.target.value)} 
                      placeholder="8GB + 256GB, 6GB + 128GB or UK 7, UK 8" 
                    />
                  </div>
                  <div className="form-group">
                    <label className="form-label">Available Colors (Comma-separated)</label>
                    <input 
                      type="text" 
                      className="input-control w-full" 
                      value={availableColors} 
                      onChange={(e) => setAvailableColors(e.target.value)} 
                      placeholder="Matte Black, Royal Purple, Classic Tan" 
                    />
                  </div>
                </div>

                <div className="form-group">
                  <label className="form-label">Image URLs</label>
                  {imageUrls.map((url, idx) => (
                    <div key={idx} style={{ display: 'flex', gap: '8px', marginBottom: '8px' }}>
                      <input 
                        type="url" 
                        className="input-control w-full" 
                        value={url} 
                        onChange={(e) => handleImageUrlChange(idx, e.target.value)} 
                        placeholder="https://images.unsplash.com/photo-..." 
                        required={idx === 0}
                      />
                      <button 
                        type="button" 
                        className="btn btn-secondary" 
                        onClick={() => removeImageField(idx)}
                        disabled={imageUrls.length <= 1}
                        style={{ padding: '0 14px' }}
                      >
                        -
                      </button>
                    </div>
                  ))}
                  <button type="button" className="btn btn-secondary small-btn" onClick={addImageField} style={{ width: 'fit-content' }}>
                    + Add Image URL Reference
                  </button>
                  
                  {/* Image Live Previews */}
                  <div className="product-image-preview-grid">
                    {imageUrls.filter(url => url.trim() !== '').map((url, idx) => (
                      <img key={idx} src={url} alt="preview" className="product-image-preview" onError={(e) => { e.target.src = 'https://images.unsplash.com/photo-1594736297302-017a8cfc330f?auto=format&fit=crop&w=100&q=80'; }} />
                    ))}
                  </div>
                </div>

                <div className="form-group">
                  <label className="form-label">Catalog Merchandising Flags</label>
                  <div className="flex-row-wrap" style={{ gap: '16px', marginTop: '4px' }}>
                    <label style={{ display: 'flex', alignItems: 'center', gap: '6px', fontSize: '13px' }}>
                      <input type="checkbox" checked={isFeatured} onChange={(e) => setIsFeatured(e.target.checked)} />
                      Featured Card
                    </label>
                    <label style={{ display: 'flex', alignItems: 'center', gap: '6px', fontSize: '13px' }}>
                      <input type="checkbox" checked={isTrending} onChange={(e) => setIsTrending(e.target.checked)} />
                      Trending Section
                    </label>
                    <label style={{ display: 'flex', alignItems: 'center', gap: '6px', fontSize: '13px' }}>
                      <input type="checkbox" checked={isNewArrival} onChange={(e) => setIsNewArrival(e.target.checked)} />
                      New Arrival
                    </label>
                    <label style={{ display: 'flex', alignItems: 'center', gap: '6px', fontSize: '13px' }}>
                      <input type="checkbox" checked={isLimitedEdition} onChange={(e) => setIsLimitedEdition(e.target.checked)} />
                      Limited Drops
                    </label>
                  </div>
                </div>
              </div>
              
              <div className="modal-footer">
                <button type="button" className="btn btn-secondary" onClick={() => setIsModalOpen(false)}>
                  Cancel
                </button>
                <button type="submit" className="btn btn-primary">
                  {editingProduct ? 'Apply Changes' : 'Confirm & Publish'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* DELETE CONFIRMATION DIALOG */}
      {confirmDeleteId && (
        <div className="modal-overlay">
          <div className="card" style={{ maxWidth: '400px', width: '90%', padding: '24px', textAlign: 'center' }}>
            <h3 style={{ fontSize: '18px', fontWeight: '700', marginBottom: '12px' }}>Confirm Catalog Deletion</h3>
            <p style={{ fontSize: '13px', color: 'var(--text-secondary)', marginBottom: '24px' }}>
              Are you sure you want to permanently remove this product from the database catalog? Active shopping carts referencing this item may be disrupted.
            </p>
            <div style={{ display: 'flex', gap: '12px', justifyContent: 'center' }}>
              <button className="btn btn-secondary" onClick={() => setConfirmDeleteId(null)}>
                Abort
              </button>
              <button className="btn btn-danger" onClick={handleConfirmDelete}>
                Delete Permanently
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
