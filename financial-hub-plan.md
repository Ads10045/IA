# Implementation Plan - Financial Hub (BNP Paribas Inspired)

Building a premium banking-style web application with Next.js, Tailwind CSS, Google Authentication, and MFA.

## 1. Project Setup
- [ ] Initialize Next.js with TypeScript and Tailwind CSS (in progress)
- [ ] Install dependencies:
  - `lucide-react` (Icons)
  - `framer-motion` (Animations)
  - `next-auth` (Authentication)
  - `clsx`, `tailwind-merge` (UI utilities)
  - `canvas-confetti` (for "pixy" / celebratory success effects)

## 2. Design System & Assets
- [ ] Define color palette (BNP Emerald: `#008a5e`, Deep Green: `#005e42`, etc.)
- [ ] Configure Tailwind theme
- [ ] Generate high-quality banker/corporate images for the login ads using `generate_image`

## 3. Login Page Implementation
- [ ] Create `LoginPage` component
- [ ] Left column: Hero section with "Access your accounts" and method selector (tabs)
- [ ] Login card: Form with "Subscriber Number" and "Access Key"
- [ ] Right column: Dynamic news/product cards with glassmorphism effects
- [ ] Implement Google Login button (styled appropriately)

## 4. Authentication Flow (Google + MFA)
- [ ] Setup NextAuth/Auth.js configuration
- [ ] Implement Google Provider
- [ ] Add MFA Step: A dedicated view for Google Authenticator code entry after successful primary login
- [ ] Add "Pixy" flow: Smooth transitions Between login steps (using Framer Motion)

## 5. Dashboard & Product List
- [ ] Layout: Sidebar navigation (dark green) + Header
- [ ] Sidebar: Accounts, Operations, Corporate Cards, Financing, etc.
- [ ] Header: Profile, Notifications (red badge), Help/Demands
- [ ] Main View: List of products (or accounts) with balances, status tags, and action buttons

## 6. Polishing & SEO
- [ ] Add micro-animations on hover
- [ ] Responsive design for mobile/tablet
- [ ] Meta tags for "Financial Hub"

---
## User Review Required
> **Clarification needed on "Pixy Flow"**: Is this a reference to a specific library (e.g., PixiJS) or a typo for "PKCE flow" / "Premium flow"? I will proceed with Framer Motion for smooth transitions unless specified.
