# Génération de code PHP Laravel depuis le DCIG

Ce document Markdown (MD) sert de base pour générer automatiquement le **code PHP Laravel** correspondant au DCIG de la plateforme de vente et paiement Cash Plus.

---

## 1. Structure du projet

```text
laravel-shop/
│
├── app/
│   ├── Http/Controllers/
│   │   ├── ProductController.php
│   │   └── PaymentController.php
│   │   └── AdminController.php
│   ├── Models/
│   │   ├── Product.php
│   │   ├── Order.php
│   │   └── User.php
│   └── Policies/ (permissions)
│
├── database/migrations/
│   ├── create_products_table.php
│   ├── create_orders_table.php
│   └── create_users_table.php
│
├── resources/views/
│   ├── shop.blade.php
│   └── admin.blade.php
│
├── routes/web.php
├── routes/api.php
└── .env
```

---

## 2. Modèles

### 2.1 Product
- id, name, price, status (PENDING, VALIDATED), timestamps

### 2.2 Order
- id, product_id, user_id, amount, status (PENDING, PAID, FAILED, VALIDATED), payment_ref, timestamps

### 2.3 User
- id, name, email, password, role (admin, vendeur, client), timestamps

---

## 3. Contrôleurs

### 3.1 ProductController
- index(): liste des produits
- shop(): vue front Blade
- store(): création produit (à valider par admin)

### 3.2 PaymentController
- create(): créer paiement carte
- webhook(): confirmation paiement

### 3.3 AdminController
- validateProduct(product_id)
- validateOrder(order_id)
- validateVirement(order_id)
- manageUsers()

---

## 4. Routes

### web.php
```php
Route::get('/', [ProductController::class, 'shop']);
Route::middleware(['auth','admin'])->group(function() {
    Route::get('/admin', [AdminController::class, 'dashboard']);
    Route::post('/admin/validate-product', [AdminController::class, 'validateProduct']);
    Route::post('/admin/validate-order', [AdminController::class, 'validateOrder']);
    Route::post('/admin/validate-virement', [AdminController::class, 'validateVirement']);
});
```

### api.php
```php
Route::post('/api/create-payment', [PaymentController::class, 'create']);
Route::post('/api/webhook-payment', [PaymentController::class, 'webhook']);
```

---

## 5. Vue Blade (Frontend)
- shop.blade.php: liste produits, bouton payer
- admin.blade.php: dashboard admin, validations, gestion utilisateurs

---

## 6. Sécurité et Rôles
- Middleware `auth` pour utilisateurs connectés
- Middleware `admin` pour actions sensibles
- Journalisation des actions administratives et transactions
- CSRF protection intégrée Laravel

---

## 7. Base de données (Migrations)
- create_products_table
- create_orders_table
- create_users_table

---

## 8. Variables d’environnement
- DB_DATABASE, DB_USERNAME, DB_PASSWORD
- PAYMENT_API_KEY
- CASHPLUS_RIB

---

## 9. Instructions pour génération
1. Copier ce MD dans un générateur ou outil IA pour code Laravel.
2. Générer les modèles avec `php artisan make:model`.
3. Générer les contrôleurs avec `php artisan make:controller`.
4. Créer les migrations et la DB.
5. Ajouter les vues Blade.
6. Configurer `.env` et la passerelle de paiement.
7. Déployer et tester localement.

---

> Ce MD est structuré pour servir de **plan directeur** afin de générer le code PHP Laravel complet basé sur le DCIG existant.