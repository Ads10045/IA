# Manuel d'Utilisation et Documentation Technique - ElitePOS ASR-2026

## 📖 Introduction
ElitePOS est une application de gestion de point de vente développée pour **ASR-2026 - Le Prestige**. Ce document détaille les fonctionnalités du logiciel, les choix technologiques et les procédures opérationnelles.

---

## 🛠️ Fiche Technique (Technologie)
L'application repose sur une architecture Java moderne pour garantir stabilité et performance.

| Composant | Technologie | Utilisation |
| :--- | :--- | :--- |
| **Langage** | Java 21 (LTS) | Logique métier et gestion des données |
| **Framework Graphique** | JavaFX 21 | Interface utilisateur fluide et responsive |
| **Build System** | Maven | Gestion des dépendances et compilation |
| **Styling** | CSS3 | Design Premium (Glassmorphism), animations |
| **Banque d'Images** | Assets Locaux | Stockage interne des images pour une rapidité 0ms |
| **Icônes** | Ikonli / FontAwesome | Symboles visuels ergonomiques |

---

## ✨ Fonctionnalités Clés

### 1. Gestion Horaire Intuitive
L'application détecte l'heure de la journée :
- **Mode Matin (Avant 12h)** : Focalise l'écran sur les petits-déjeuners et les formules brunch.
- **Mode Journée** : Débloque l'accès à toute la carte (Plats internationaux, Marocain, Burgers, Desserts).

### 2. Personnalisation Avancée des Formules
Le module "Formules" guide l'utilisateur à travers 5 étapes cruciales :
- **Boissons** : Choix séparé entre boissons chaudes et jus de fruits frais (Citron, Banane, Orange).
- **Plats & Boulangerie** : Sélection visuelle simplifiée.
- **Multi-sélection** : À l'étape 5 (Accompagnements), il est possible de cocher plusieurs extras (ex : Olives + Fromage + Miel).

### 3. Cycle de Paiement Sécurisé
- **Vérification de Solde** : Le logiciel empêche la clôture d'une table si le montant "CASH RECU" est insuffisant par rapport au total dû.
- **Gestion de la Monnaie** : Calcul automatique du rendu affiché sur le ticket de caisse électronique.
- **Libération des Tables** : Une fois encaissée, la table disparaît de la liste active pour laisser place au client suivant.

---

## 🚀 Guide d'Utilisation (Comment utiliser)

### Étape 1 : Installation
Assurez-vous d'avoir Java 21 installé, puis lancez la commande suivante dans le dossier du projet :
```bash
mvn clean javafx:run
```

### Étape 2 : Ouverture d'une Table
1. Cliquez sur le bouton **TABLE** en haut de l'écran. 
2. Saisissez le numéro de table souhaité sur le pavé numérique.
3. Validez pour accéder au menu.

### Étape 3 : Saisie des Commandes
- Cliquez sur un produit pour l'ajouter. 
- Pour une **Formule**, une fenêtre surgissante (popup) s'ouvre. Faites vos choix étape par étape, puis cliquez sur **AJOUTER À LA COMMANDE**.
- Le ticket à gauche se met à jour instantanément. Cliquez sur la **corbeille** pour retirer un article.

### Étape 4 : Paiement et Clôture
1. Cliquez sur **ENCAISSER** (ou PAYER) en bas à gauche du ticket.
2. Sur le pavé de droite, tapez le montant donné par le client.
3. Si le montant est suffisant, cliquez sur le bouton vert **ENCAISSER**. 
4. Si le montant est insuffisant, il s'affichera en **rouge** ; vous devrez corriger la saisie avant de valider.

---

## 📂 Organisation du Projet
- `src/main/java` : Code source Java.
- `src/main/resources/images` : Banque d'images locale (produits et options).
- `theme.css` : Feuille de style contrôlant l'apparence visuelle.

---
*Document produit le 25 Décembre 2025 pour Le Prestige - Casablanca.*
