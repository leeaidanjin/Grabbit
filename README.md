# Grabbit – Mobile Self-Checkout App

Grabbit is a mobile app that turns any iPhone into a self-checkout system for quick, small purchases. Built with SwiftUI, Stripe, Auth0, and Firebase, it helps users scan items, pay in-app, and skip the line—while stores get verified digital receipts.

---

## Features

- Secure login via Auth0
- Map view of "Grabbit-enabled stores"
- In-app item search & scanner (using Vision)
- Cart management with live total
- Stripe-powered checkout
- Receipt history saved via Firebase
- Barcode detection & camera zoom
- Animated confirmation after payment

---

## Getting Started

### Requirements

- Xcode 15+
- iOS 17+
- Firebase project (Firestore & Auth enabled)
- Stripe account
- Auth0 account

---

## Installation

1. **Clone the Repo**
   ```bash
   git clone https://github.com/yourusername/grabbit.git
   cd grabbit

2. Install CocoaPods Dependencies
    sudo gem install cocoapods
    pod install

3. Open the .xcworkspace file in Xcode
    open Grabbit.xcworkspace

4. Configure Firebase
  - Add your GoogleService-Info.plist to the root of the Xcode project.
  - Ensure Firestore and Authentication (Email/Password or third-party) are enabled in the Firebase Console.

5. Set Stripe Key Inside GrabbitApp.swift:
     StripeAPI.defaultPublishableKey = "YOUR_STRIPE_PUBLISHABLE_KEY"

6. Set Auth0 Info Update the Auth0.plist or replace the values inside the LoginView with your Auth0 domain and client ID.

