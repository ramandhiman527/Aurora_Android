import React, { useState, useEffect } from 'react';
import { dbService } from '../firebase/db';
import { Send, Users, Bell, Clock, Smartphone, Sparkles, CheckCircle2 } from 'lucide-react';

export default function NotificationManagement() {
  const [campaigns, setCampaigns] = useState([]);
  const [title, setTitle] = useState('');
  const [message, setMessage] = useState('');
  const [target, setTarget] = useState('all');
  const [isLoading, setIsLoading] = useState(false);
  const [successMsg, setSuccessMsg] = useState('');

  useEffect(() => {
    fetchCampaigns();
  }, []);

  const fetchCampaigns = async () => {
    try {
      const data = await dbService.getPushCampaigns();
      setCampaigns(data);
    } catch (error) {
      console.error('Failed to fetch campaigns:', error);
    }
  };

  const handleBroadcast = async (e) => {
    e.preventDefault();
    if (!title.trim() || !message.trim()) return;

    setIsLoading(true);
    setSuccessMsg('');
    try {
      const newCampaign = {
        title,
        message,
        target,
        clicks: 0
      };

      await dbService.sendBroadcastNotification(newCampaign);
      setSuccessMsg('FCM Broadcast Dispatched Successfully!');
      setTitle('');
      setMessage('');
      setTarget('all');
      
      // Refresh list
      await fetchCampaigns();
      
      // Clear success alert after 3 seconds
      setTimeout(() => {
        setSuccessMsg('');
      }, 3000);
    } catch (error) {
      console.error('Failed to send broadcast:', error);
    } finally {
      setIsLoading(false);
    }
  };

  const formatTimestamp = (isoString) => {
    if (!isoString) return '';
    const date = new Date(isoString);
    return date.toLocaleString('en-US', {
      month: 'short',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    });
  };

  const getTargetBadgeClass = (targetType) => {
    switch (targetType) {
      case 'all': return 'badge-info';
      case 'bronze': return 'badge-secondary';
      case 'silver': return 'badge-primary';
      case 'gold': return 'badge-warning';
      case 'platinum': return 'badge-success';
      default: return 'badge-info';
    }
  };

  return (
    <div className="animate-fade-in">
      <div className="header">
        <div className="header-title">
          <h1>Push Broadcast Concierge</h1>
          <p>Compose and dispatch real-time push notifications to Aura users' mobile apps</p>
        </div>
      </div>

      <div className="sub-panel-grid">
        {/* Composer Form */}
        <div className="card">
          <div className="card-header">
            <h3 className="card-title" style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
              <Sparkles size={18} className="icon-blue" />
              Compose Broadcast Campaign
            </h3>
          </div>

          {successMsg && (
            <div className="badge badge-success" style={{ width: '100%', padding: '12px', borderRadius: '8px', marginBottom: '16px', display: 'flex', gap: '8px', fontSize: '13px' }}>
              <CheckCircle2 size={16} />
              {successMsg}
            </div>
          )}

          <form onSubmit={handleBroadcast}>
            <div className="form-group">
              <label className="form-label">Notification Title</label>
              <input
                type="text"
                className="input-control"
                placeholder="e.g. Midnight Drop Alert ⚡"
                value={title}
                onChange={(e) => setTitle(e.target.value)}
                required
              />
            </div>

            <div className="form-group">
              <label className="form-label">Message Body</label>
              <textarea
                className="input-control"
                rows="4"
                placeholder="Write a premium description that invites interaction..."
                value={message}
                onChange={(e) => setMessage(e.target.value)}
                required
                style={{ resize: 'vertical', fontFamily: 'inherit' }}
              />
            </div>

            <div className="form-group">
              <label className="form-label">Target Audience Segment</label>
              <select
                className="input-control select-control"
                value={target}
                onChange={(e) => setTarget(e.target.value)}
              >
                <option value="all">All Aura Customers</option>
                <option value="bronze">Bronze Class Members</option>
                <option value="silver">Silver Class Members</option>
                <option value="gold">Gold Class VIPs</option>
                <option value="platinum">Platinum Elite Members</option>
              </select>
            </div>

            <button
              type="submit"
              className="btn btn-primary w-full"
              disabled={isLoading || !title.trim() || !message.trim()}
              style={{ marginTop: '10px' }}
            >
              <Send size={16} />
              {isLoading ? 'Dispatching FCM Broadcast...' : 'Broadcast Live Alert'}
            </button>
          </form>
        </div>

        {/* Campaign History Log */}
        <div className="card">
          <div className="card-header">
            <h3 className="card-title" style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
              <Clock size={18} />
              Historical Campaign Logs
            </h3>
            <span className="badge badge-info">{campaigns.length} Sent</span>
          </div>

          <div style={{ display: 'flex', flexDirection: 'column', gap: '16px', maxHeight: '500px', overflowY: 'auto', paddingRight: '4px' }}>
            {campaigns.length === 0 ? (
              <div style={{ textAlign: 'center', padding: '40px 0', color: 'var(--text-muted)' }}>
                <Smartphone size={32} style={{ marginBottom: '12px', strokeWidth: '1.5' }} />
                <p>No broadcast campaigns found</p>
              </div>
            ) : (
              campaigns.map((camp) => (
                <div 
                  key={camp.id} 
                  style={{
                    border: '1px solid var(--border-color)',
                    borderRadius: 'var(--border-radius-sm)',
                    padding: '16px',
                    backgroundColor: 'var(--bg-tertiary)',
                    display: 'flex',
                    flexDirection: 'column',
                    gap: '8px'
                  }}
                >
                  <div style={{ display: 'flex', justifyContent: 'between', alignItems: 'center', flexWrap: 'wrap', gap: '8px' }}>
                    <span className={`badge ${getTargetBadgeClass(camp.target)}`}>
                      Target: {camp.target}
                    </span>
                    <span style={{ fontSize: '11px', color: 'var(--text-muted)', display: 'flex', alignItems: 'center', gap: '4px' }}>
                      <Clock size={12} />
                      {formatTimestamp(camp.timestamp)}
                    </span>
                  </div>

                  <h4 style={{ fontSize: '14px', fontWeight: '600', color: 'var(--text-primary)' }}>
                    {camp.title}
                  </h4>
                  
                  <p style={{ fontSize: '13px', color: 'var(--text-secondary)', lineHeight: '1.4' }}>
                    {camp.message}
                  </p>

                  <div style={{ borderTop: '1px dashed var(--border-color)', paddingTop: '8px', marginTop: '4px', display: 'flex', justifyContent: 'between', fontSize: '12px', color: 'var(--text-muted)' }}>
                    <span>Clicks Generated</span>
                    <span style={{ fontWeight: '600', color: 'var(--text-primary)' }}>
                      {camp.clicks} clicks
                    </span>
                  </div>
                </div>
              ))
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
