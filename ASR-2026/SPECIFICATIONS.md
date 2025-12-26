# 📂 SPECIFICATIONS.md — Système de Caisse Restaurant Élite

## 💎 1. Charte Graphique & Design (UI/UX)
Le système doit offrir une expérience visuelle "Premium" pour s'intégrer dans des établissements haut de gamme.

**Style** : Minimalisme Moderne (Inspiration Apple/Stripe).

**Palette de Couleurs** :
*   **Fond Principal** : `#121212` (Dark Mode profond)
*   **Surface** : `#1E1E1E` (Cartes et menus)
*   **Accent** : `#D4AF37` (Or Sablé) pour les actions positives.
*   **Danger** : `#E74C3C` (Rouge doux) pour les annulations.

**Composants JavaFX** :
*   Utilisation de JMetro ou de CSS personnalisés pour supprimer l'aspect "standard" de Java.
*   Bords arrondis de **12px** sur tous les éléments tactiles.
*   Transitions de fenêtres en "Fade In" pour une sensation de fluidité.

## 🍽️ 2. Logique Métier : Gestion des Tables & Flux
Le système remplace le carnet de notes traditionnel par une gestion d'état intelligente.

**Cycle de Vie d'une Table**
1.  **Libre (Vacant)** : La table est affichée en contour gris fin sur le plan de salle.
2.  **Arrivée** : Le serveur touche la table -> Pop-up élégant pour saisir le nombre de personnes (ex: 4).
3.  **Occupée (Occupied)** : La table devient Or/Ambre. Une commande est créée en arrière-plan.
4.  **Prise de Commande** : Sélection des plats via une grille d'images HD. Chaque ajout met à jour l'écran client instantanément.
5.  **Paiement (Billing)** : Impression du ticket -> Sélection du mode de paiement -> Clôture.

## 🌍 3. Internationalisation (i18n) & Externalisation
Le logiciel doit être prêt pour l'exportation sans modification du code.

**Langues** : Gestion via `ResourceBundle` (.properties) pour le français, l'anglais et l'arabe (gestion du RTL si nécessaire).

**Fichier de Configuration Externe (`config.json`)** :
```json
{
  "currency_symbol": "€",
  "tax_rate": 0.20,
  "restaurant_name": "Le Prestige",
  "theme": "dark-gold"
}
```

## 🏗️ 4. Architecture Technique (Java 17+)
**Modèle de Données (UML)**
Le projet repose sur une séparation stricte des responsabilités :
*   `TableManager` : Singleton gérant l'état de la salle.
*   `Order` : Objet contenant la liste des produits, les remises et le calcul des taxes.
*   `PrintEngine` : Service de conversion des données en commandes binaires ESC/POS.

**Gestion du Double Écran**
Utilisation de deux Stages (fenêtres) JavaFX :
1.  **Stage 1 (Principal)** : Tactile, interactif, réservé au personnel.
2.  **Stage 2 (Secondaire)** : Affichage passif, projeté sur l'écran face au client (Détails commande + Publicités).

## 🖨️ 5. Spécifications de l'Imprimante
L'imprimante thermique intégrée doit produire des tickets structurés :
*   **Header** : Logo en noir et blanc (600dpi).
*   **Body** : Police élégante, alignement à gauche pour les noms, à droite pour les prix.
*   **Footer** : Texte légal de TVA et QR Code pour le suivi de fidélité.

## 🚀 Plan d'Action (Roadmap)
*   **Phase 1** : Création du moteur CSS et du thème "Élégant".
*   **Phase 2** : Développement du module i18n et lecture du fichier config.
*   **Phase 3** : Implémentation du plan de salle interactif (Drag & Drop des tables).
*   **Phase 4** : Logique de commande et liaison avec l'écran client.
*   **Phase 5** : Tests d'impression et finalisation du packaging (EXE/JAR).
