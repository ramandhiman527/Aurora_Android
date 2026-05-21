import { initializeApp, getApps, getApp } from 'firebase/app';
import { getFirestore } from 'firebase/firestore';
import { getAuth } from 'firebase/auth';

const firebaseConfig = {
  apiKey: import.meta.env.VITE_FIREBASE_API_KEY,
  authDomain: import.meta.env.VITE_FIREBASE_AUTH_DOMAIN,
  projectId: import.meta.env.VITE_FIREBASE_PROJECT_ID,
  storageBucket: import.meta.env.VITE_FIREBASE_STORAGE_BUCKET,
  messagingSenderId: import.meta.env.VITE_FIREBASE_MESSAGING_SENDER_ID,
  appId: import.meta.env.VITE_FIREBASE_APP_ID
};

// Check if we have valid-looking credentials to use real Firebase
const isFirebaseConfigured = 
  firebaseConfig.apiKey && 
  firebaseConfig.apiKey !== "YOUR_API_KEY" && 
  firebaseConfig.projectId;

let firebaseApp = null;
let firestore = null;
let firebaseAuth = null;

if (isFirebaseConfigured) {
  try {
    firebaseApp = getApps().length === 0 ? initializeApp(firebaseConfig) : getApp();
    firestore = getFirestore(firebaseApp);
    firebaseAuth = getAuth(firebaseApp);
    console.log("🔥 Firebase initialized successfully.");
  } catch (error) {
    console.warn("⚠️ Firebase initialization failed, falling back to local simulation:", error);
  }
} else {
  console.log("ℹ️ No Firebase keys detected. Running in Local Simulation (mock fallback) mode.");
}

export { isFirebaseConfigured, firestore, firebaseAuth };
