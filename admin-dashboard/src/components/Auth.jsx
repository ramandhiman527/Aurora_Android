import React, { useState } from 'react';
import { ShieldCheck, Mail, Lock, Phone } from 'lucide-react';

export default function Auth({ onLoginSuccess }) {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [phone, setPhone] = useState('');
  const [otp, setOtp] = useState('');
  const [usePhoneLogin, setUsePhoneLogin] = useState(false);
  const [otpRequested, setOtpRequested] = useState(false);
  const [error, setError] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  const handleEmailSubmit = (e) => {
    e.preventDefault();
    setError('');
    setIsLoading(true);

    setTimeout(() => {
      // Demo credentials check
      if (email === 'admin@aura.com' && password === 'adminpass') {
        setIsLoading(false);
        onLoginSuccess({ email, role: 'admin' });
      } else if (email === 'admin' && password === 'admin') {
        setIsLoading(false);
        onLoginSuccess({ email: 'admin@aura.com', role: 'admin' });
      } else {
        setIsLoading(false);
        setError('Invalid administrator email or passphrase.');
      }
    }, 1000);
  };

  const handlePhoneRequestOtp = (e) => {
    e.preventDefault();
    if (phone.length < 10) {
      setError('Please enter a valid 10-digit mobile number.');
      return;
    }
    setError('');
    setIsLoading(true);

    setTimeout(() => {
      setIsLoading(false);
      setOtpRequested(true);
    }, 1000);
  };

  const handlePhoneVerifyOtp = (e) => {
    e.preventDefault();
    setIsLoading(true);

    setTimeout(() => {
      setIsLoading(false);
      if (otp === '1234' || otp.length === 4) {
        onLoginSuccess({ phone, role: 'admin' });
      } else {
        setError('Invalid OTP code. Try 1234.');
      }
    }, 1000);
  };

  const handleQuickBypass = () => {
    onLoginSuccess({ email: 'admin@aura.com', role: 'admin' });
  };

  return (
    <div className="auth-container">
      <div className="card auth-card animate-fade-in">
        <div className="auth-logo">AURA</div>
        <div className="auth-subtitle">Corporate Management Terminal</div>
        
        <h2>Administrator Access</h2>
        <p>Authenticate with your credentials to manage shop products, tracking logistics, and wallets.</p>

        {error && (
          <div 
            className="badge badge-danger w-full" 
            style={{ padding: '10px 14px', borderRadius: '6px', marginBottom: '20px', display: 'block', textAlign: 'center' }}
          >
            {error}
          </div>
        )}

        {!usePhoneLogin ? (
          /* Email Login Form */
          <form onSubmit={handleEmailSubmit}>
            <div className="form-group">
              <label className="form-label">Email Address</label>
              <div style={{ position: 'relative' }}>
                <Mail size={16} style={{ position: 'absolute', left: '14px', top: '15px', color: 'var(--text-muted)' }} />
                <input 
                  type="text" 
                  className="input-control w-full" 
                  placeholder="admin@aura.com"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  style={{ paddingLeft: '44px' }}
                  required
                />
              </div>
            </div>

            <div className="form-group">
              <label className="form-label">Passphrase</label>
              <div style={{ position: 'relative' }}>
                <Lock size={16} style={{ position: 'absolute', left: '14px', top: '15px', color: 'var(--text-muted)' }} />
                <input 
                  type="password" 
                  className="input-control w-full" 
                  placeholder="••••••••"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  style={{ paddingLeft: '44px' }}
                  required
                />
              </div>
            </div>

            <button 
              type="submit" 
              className="btn btn-primary w-full" 
              style={{ padding: '14px', marginTop: '10px' }}
              disabled={isLoading}
            >
              {isLoading ? 'Verifying Authentication...' : 'Secure Authorization'}
            </button>
          </form>
        ) : (
          /* Phone OTP Login Form */
          <form onSubmit={otpRequested ? handlePhoneVerifyOtp : handlePhoneRequestOtp}>
            {!otpRequested ? (
              <div className="form-group">
                <label className="form-label">Mobile Number</label>
                <div style={{ position: 'relative', display: 'flex' }}>
                  <div 
                    style={{ 
                      padding: '12px 14px', 
                      background: 'var(--bg-tertiary)', 
                      border: '1px solid var(--border-color)',
                      borderRight: 'none',
                      borderRadius: '8px 0 0 8px',
                      fontSize: '14px',
                      color: 'var(--text-secondary)'
                    }}
                  >
                    +91
                  </div>
                  <input 
                    type="tel" 
                    className="input-control w-full" 
                    placeholder="98765 43210"
                    maxLength="10"
                    value={phone}
                    onChange={(e) => setPhone(e.target.value.replace(/\D/g, ''))}
                    style={{ borderRadius: '0 8px 8px 0' }}
                    required
                  />
                </div>
              </div>
            ) : (
              <div className="form-group">
                <label className="form-label">Verification Code (OTP)</label>
                <div style={{ position: 'relative' }}>
                  <input 
                    type="text" 
                    className="input-control w-full" 
                    placeholder="Enter 4-digit code (e.g. 1234)"
                    maxLength="4"
                    value={otp}
                    onChange={(e) => setOtp(e.target.value.replace(/\D/g, ''))}
                    required
                  />
                </div>
                <span style={{ fontSize: '11px', color: 'var(--text-muted)' }}>Sent SMS OTP code to +91 {phone}</span>
              </div>
            )}

            <button 
              type="submit" 
              className="btn btn-primary w-full" 
              style={{ padding: '14px', marginTop: '10px' }}
              disabled={isLoading}
            >
              {isLoading 
                ? 'Processing...' 
                : (otpRequested ? 'Verify OTP & Continue' : 'Request OTP Code')}
            </button>
          </form>
        )}

        <div style={{ margin: '20px 0', borderBottom: '1px solid var(--border-color)' }}></div>

        <button 
          className="btn btn-secondary w-full" 
          onClick={() => {
            setUsePhoneLogin(!usePhoneLogin);
            setOtpRequested(false);
            setError('');
          }}
        >
          {usePhoneLogin ? 'Sign In with Email' : 'Sign In with SMS OTP'}
        </button>

        <div className="auth-bypass">
          <p style={{ margin: 0, fontSize: '11px', textAlign: 'center' }}>
            🔒 Evaluation Mode Active:
            <br />
            Enter **admin** / **admin** above, or use phone with OTP **1234**, or click below to bypass instantly:
          </p>
          <button 
            onClick={handleQuickBypass} 
            className="btn btn-primary small-btn" 
            style={{ width: '100%', marginTop: '8px', padding: '6px', fontSize: '11px' }}
          >
            Quick Evaluation Bypass
          </button>
        </div>
      </div>
    </div>
  );
}
