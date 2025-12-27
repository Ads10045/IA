# Spécifications de Migration : Financial Hub (Next.js vers Angular)

Ce document sert de référence complète pour reconstruire l'application **Financial Hub** en **Angular 18+**. Il détaille l'architecture, les règles de gestion (RG), les flux d'authentification et l'interface utilisateur.

---

## 1. Stack Technique & Architecture

*   **Framework** : Angular 18+ (Standalone Components).
*   **Langage** : TypeScript.
*   **Styling** : Tailwind CSS (configuration identique au projet Next.js).
*   **State Management** : Services Angular (RxJS BehaviorSubject si besoin de réactivité globale).
*   **Bibliothèques tierces requises** :
    *   `qrcode` : Pour la génération de QR Code MFA.
    *   `canvas-confetti` : Pour l'animation de succès.
    *   `otplib` (optionnel côté client, ou logique simple de vérification côté service).
    *   `lucide-angular` (ou SVGs inline) : Pour les icônes.

---

## 2. Règles de Gestion (RG) & Flux d'Authentification

### 2.1. Tableau de Bord de Connexion (Login Page)

L'écran de connexion doit comporter 3 onglets principaux :
1.  **Clé Digitale** (Défaut).
2.  **Mot de passe**.
3.  **Cloud / SSO**.

#### RG-01 : Identification "Clé Digitale" & "Mot de passe"
*   **Champs** : Identifiant (ex: `26626656` ou email) + Mot de passe.
*   **Option "Enregistrer ce navigateur"** :
    *   Case à cocher visible uniquement sur ces onglets.
    *   Action : Appel API (simulé) pour enregistrer le User Agent + Timestamp.
    *   Feedback : Afficher "Navigateur enregistré !" en vert pendant 3s.
*   **Logique de validation** :
    *   **Cas Démo (Backdoor)** : Si l'identifiant est `26626656`.
        *   Ignorer le mot de passe.
        *   Simuler un délai (800ms).
        *   Passer directement à l'étape MFA.
    *   **Cas Normal** :
        *   Vérifier l'existence de l'utilisateur dans la liste (Service Mock).
        *   Si utilisateur trouvé : Passer à l'étape MFA.
        *   Sinon : Afficher erreur "Identifiant incorrect".

#### RG-02 : Identification "Cloud / SSO"
*   **Champs** : Identifiant Client / Email.
*   **Boutons** : "IBM Cloud" et "Azure AD".
*   **Logique** :
    *   L'utilisateur saisit son ID/Email.
    *   Clic sur un fournisseur (ex: IBM Cloud).
    *   Appel API simulé (`/api/auth/ibm/direct-login`).
    *   Si succès : Redirection directe ou MFA selon la configuration (ici MFA).

### 2.2. Multi-Factor Authentication (MFA)

Après une validation réussie de la première étape (`step = 'login' -> 'mfa'`), l'utilisateur doit valider son identité.

#### RG-03 : Méthodes MFA
L'utilisateur a le choix entre deux méthodes (boutons toggle) :
1.  **Application** (Google Authenticator / Microsoft Authenticator).
2.  **SMS**.

#### RG-04 : Flux Application (QR Code)
*   **Génération** :
    *   À l'initialisation de l'étape MFA, générer un secret (base32).
    *   Créer une URL `otpauth://totp/FinancialHub:USER_ID?secret=SECRET&issuer=FinancialHub`.
    *   Convertir cette URL en QR Code (Data URL) via la librairie `qrcode`.
*   **Affichage** : Afficher le QR Code généré au centre.
*   **Validation** :
    *   L'utilisateur saisit un code à 6 chiffres.
    *   Vérification : Soit via `otplib.check(token, secret)`, soit validation simple (longueur 6 chiffres) pour la démo.
    *   **UX Saisie** : 6 champs de saisie (inputs) séparés.
        *   Auto-focus sur le champ suivant lors de la saisie.
        *   Auto-focus sur le précédent lors du `Backspace`.
        *   **Important** : Empêcher la double saisie (force 1 caractère max par case).

#### RG-05 : Flux SMS
*   **Affichage** : Masquer le numéro de téléphone (ex: `** ** ** 45`).
*   **Action "Envoyer le code"** :
    *   Bouton visible initialement.
    *   Au clic : Simuler un envoi (délai 1.5s), puis afficher "Code SMS de simulation : 888888".
    *   Passer l'état à `smsSent = true`.
*   **Validation** :
    *   Le code attendu est strictement `888888`.

### 2.3. Succès & Session

#### RG-06 : Connexion Réussie
*   Si le code MFA est valide :
    1.  Afficher l'étape `success` (Animation Check Circle vert).
    2.  Déclencher l'effet **Confetti**.
    3.  Créer un **Cookie** `auth_token` (Expiration 7 jours).
        *   Format du cookie : `ibm-direct-session-{USER_ID}` ou `valid-session`.
    4.  Rediriger vers `/dashboard` après 2.5 secondes.

---

## 3. Données & Modèles

### 3.1. Interface Utilisateur (`User`)
```typescript
interface User {
  id: string; // ex: "26626656"
  firstName: string;
  lastName: string;
  email: string; // ex: "marc.dupont@financialhub.com"
  phone: string; // ex: "0612345678"
  role: string; // ex: "Admin"
  status: string; // ex: "Active"
  lastLogin: string; // ISO Date
}
```

### 3.2. Browser Registration Payload
```typescript
interface BrowserRegistration {
    userAgent: string;
    timestamp: string;
    // ip: string (géré côté serveur)
}
```

---

## 4. Structure Angular Recommandée

### 4.1. Arborescence
```
src/
  app/
    models/
      user.model.ts
    services/
      user.service.ts       # Gestion des utilisateurs (Mock Data)
      auth.service.ts       # Logique de connexion, MFA, Cookies, Session
    login/
      login.component.ts    # Logique principale (Wizard: Login -> MFA -> Success)
      login.component.html  # Template avec onglets et animations
      login.component.css   # Styles spécifiques (animations fade-in)
    dashboard/
      dashboard.component.ts
      layout/               # Sidebar, Header
```

### 4.2. Implémentation du `LoginComponent`
Le composant doit gérer une machine à états simple :
*   `step`: `'login' | 'mfa' | 'success'`
*   `loginTab`: `'cle-digitale' | 'password' | 'sso'`
*   `mfaMethod`: `'app' | 'sms'`

---

## 5. Design UI (Tailwind CSS)

### Couleurs
*   **Primaire (BNP Emerald)** : `bg-[#008a5e]`, `text-[#008a5e]` (Approximation Emerald-600/700).
*   **Arrière-plan** : `bg-gray-50`.
*   **Erreur** : `text-red-500`, `border-red-500`.

### Typographie
*   Police : Sans-serif par défaut (Inter ou Roboto recommandé).

### Layout
*   **Split Screen** :
    *   **Gauche (Desktop 5/12)** : Formulaire de connexion.
    *   **Droite (Desktop 7/12)** : Bannière promotionnelle (Image + Texte Overlay + Cartes en bas).

---

## 6. Instructions de Migration (Pas à Pas)

1.  **Initialisation** : Créer un projet Angular (`ng new financial-hub-angular --style=css`).
2.  **Tailwind** : Installer et configurer Tailwind CSS.
3.  **Services** : Créer `UserService` avec les données Mock (copiées de `users.json`).
4.  **Login Component** :
    *   Intégrer le HTML statique basé sur le design React.
    *   Implémenter la logique des onglets (`*ngIf`).
    *   Ajouter `FormsModule` pour le binding `[(ngModel)]`.
5.  **MFA Logic** :
    *   Installer `qrcode`.
    *   Implémenter `generateQrCode()` dans le composant.
    *   Gérer la saisie OTP (attention à la gestion du focus et `preventDefault`).
6.  **Animations** :
    *   Utiliser `@angular/animations` pour les transitions de step (`:enter`, `:leave`) ou des classes CSS conditionnelles simples.
    *   Installer `canvas-confetti` pour le succès.
7.  **Dashboard** :
    *   Créer une route protégée (Guard vérifiant le cookie `auth_token`).
    *   Afficher les infos de l'utilisateur connecté via `UserService`.

---

## 7. Configuration Cloud & Authenticator

Cette section détaille les paramètres nécessaires pour l'intégration avec **IBM Cloud App ID** et la configuration des applications d'authentification (MFA).

### 7.1. IBM Cloud App ID (SSO)
Pour la partie "Cloud / SSO", l'application doit interagir avec l'instance App ID configurée.

*   **Service Name**: `financial-hub-appid`
*   **Region**: `us-south` (ou votre région spécifique)
*   **Tenant ID**: `(À récupérer depuis la console IBM Cloud)`
*   **Client ID**: `(À récupérer depuis les credentials App ID)`
*   **Secret**: `(À récupérer et stocker en variables d'environnement)`
*   **Endpoint RO (Resource Owner)**: `/oauth/v4/{tenant_id}/token`
    *   Utilisé pour le flux "Direct Login" (ROPC) où l'application envoie username/password directement.

**Variables d'environnement requises (Angular - `src/environments/environment.ts`)** :
```typescript
export const environment = {
  production: false,
  ibm: {
    authEndpoint: 'https://us-south.appid.cloud.ibm.com/oauth/v4/',
    clientId: 'YOUR_CLIENT_ID',
    // Le secret ne doit jamais être exposé côté client Angular. 
    // L'appel doit passer par un backend proxy ou une Azure/AWS Function si besoin.
  }
};
```

### 7.2. Authenticator & QR Code (Standard TOTP)
Pour assurer la compatibilité avec **Google Authenticator** et **Microsoft Authenticator**, le format de l'URI contenu dans le QR Code doit respecter strictement le standard URI Key Format.

**Format URI :**
```text
otpauth://totp/{Issuer}:{AccountName}?secret={Secret}&issuer={Issuer}&algorithm=SHA1&digits=6&period=30
```

**Implémentation dans Angular (`login.component.ts`) :**
*   **Issuer** : `FinancialHub` (Nom qui apparaîtra dans l'app)
*   **AccountName** : `26626656` ou `marc.dupont@email.com` (Identifiant de l'utilisateur)
*   **Secret** : Chaîne Base32 (ex: `JBSWY3DPEHPK3PXP`). Pour la démo, un secret fixe peut être utilisé ou généré aléatoirement par session.
*   **Librairie JS** : Utiliser `qrcode` pour transformer cette URI en image `data:image/png;base64,...`.

**Exemple de code génération :**
```typescript
const secret = 'JBSWY3DPEHPK3PXP'; // Base32 Secret
const issuer = 'FinancialHub';
const account = this.currentUser.id;
const otpauth = `otpauth://totp/${issuer}:${account}?secret=${secret}&issuer=${issuer}&algorithm=SHA1&digits=6&period=30`;

// Génération de l'image
QRCode.toDataURL(otpauth, (err, imageUrl) => {
    if (!err) this.qrCodeUrl = imageUrl;
});
```
*Note: Microsoft Authenticator peut parfois nécessiter que l'issuer soit passé deux fois (dans le path et en paramètre) pour un affichage optimal, ce que respecte le format ci-dessus.*
