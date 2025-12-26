# ElitePOS - ASR-2026 - LE PRESTIGE

ElitePOS est une solution de point de vente (POS) logicielle ultra-moderne et performante, spécifiquement conçue pour la gestion complète d'un restaurant ou d'un café. Elle allie élégance visuelle (Glassmorphism), rapidité (images locales) et sécurité métier.

## 🚀 Fonctionnalités Principales

### 1. Gestion Tactile des Tables
- **Ouverture Rapide** : Saisie du numéro de table et du nombre de couverts via un pavé numérique stylisé (icônes motif tigre).
- **Tableau de Bord** : Liste dynamique à droite affichant toutes les tables actives en temps réel pour un basculement rapide entre les clients.

### 2. Menu Intelligent & Catégories
- **Auto-Adaptation** : Le menu affiche automatiquement les **Formules** et **Petit-Déjeuner** le matin (06h-12h) et la carte complète le reste de la journée.
- **Nouvelle Catégorie Desserts** : Une section dédiée aux douceurs (Fondant, Cheesecake, etc.) avec visuels HD.
- **Images Locales** : Toutes les photos sont stockées dans le projet pour un affichage instantané sans dépendance à Internet.

### 3. Configurateur de Formules Avancé (5 Étapes)
Une interface étape par étape unique pour composer vos menus :
1.  **Boisson Chaude** (Café, Thé, Lait, Chocolat...)
2.  **Jus Frais** (Orange, Citron, Banane...)
3.  **Plat Principal** (Omelette, Pizza Marocaine, Pancakes...)
4.  **Boulangerie** (Croissant, Pain au chocolat, Petit pain...)
5.  **Accompagnements (Multi-sélection)** : Possibilité de choisir plusieurs extras (Huile, Fromage, Olives, Miel) simultanément.

### 4. Facturation Réaliste & Encaissement sécurisé
- **Ticket Thermique** : Visualisation en temps réel d'un ticket de caisse certifié avec Sous-total, TVA (20%) et Total TTC.
- **Validation du Paiement** : Sécurité intégrée qui bloque l'encaissement si le montant reçu saisi est inférieur au montant total à payer (le montant s'affiche en rouge pour alerter l'utilisateur).
- **Calcul de Rendu** : Calcul automatique de la monnaie à rendre au client.

## 🛠️ Documentation Technique

### Stack Technologique
- **Langage** : Java 21 LTS.
- **Framework UI** : JavaFX 21 (Architecture modulaire).
- **Gestionnaire de projet** : Maven.
- **Design System** : 
    - **CSS Personnalisé** : Thème premium avec Glassmorphism, gradients et bordures arrondies.
    - **Ikonli/FontAwesome** : Bibliothèque d'icônes vectorielles.
- **Performance** : Mise en cache locale des assets graphiques (images produits et chiffres du pavé).

### Architecture des fichiers
- `ElitePOS.java` : Contrôleur principal gérant l'UI et la logique de navigation.
- `MenuService.java` : Base de données locale des produits, catégories et prix.
- `model/` : Contient les objets `TableSession`, `Product` et `OrderItem`.

## 📥 Guide d'Utilisation

### Pré-requis
- **JDK 21** ou supérieur.
- **Maven** installé.

### Lancer l'application
Exécutez la commande suivante dans votre terminal à la racine du projet :
```bash
mvn clean javafx:run
```

### Comment utiliser (Flux standard) :
1.  **Choisir une table** : Cliquez sur le bouton "TABLE" en haut à droite, saisissez le numéro via le pavé numérique et validez.
2.  **Ajouter des produits** : Cliquez sur les cartes produits. Pour les **Formules**, suivez les 5 étapes de personnalisation.
3.  **Gérer la commande** : Utilisez l'icône corbeille sur le ticket à gauche pour supprimer des articles.
4.  **Encaisser** : 
    - Cliquez sur le bouton vert **ENCAISSER** ou **PAYER**.
    - Saisissez le montant reçu du client sur le pavé numérique de droite.
    - Si le montant est correct, validez avec **ENCAISSER**. La table est automatiquement fermée et archivée.
5.  **Retour** : Le bouton "RETOUR" permet de revenir à la sélection des produits sans valider le paiement.

---
*© 2026 - ASR Le Prestige - Excellence en Restauration.*
