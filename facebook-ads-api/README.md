# 📘 Guide de Configuration Facebook Ads API

Pour faire fonctionner cette API, vous avez besoin de deux choses essentielles de Facebook :
1.  Un **Access Token** (Le code secret pour lire les données).
2.  Un **Page ID** (L'identifiant de la page Facebook que vous voulez afficher).

## 🛠 Étape 1 : Créer une App Facebook
1.  Allez sur [developers.facebook.com/apps](https://developers.facebook.com/apps/).
2.  Cliquez sur **"Créer une App"**.
3.  Sélectionnez **"Autre"** -> **"Suivant"**.
4.  Sélectionnez **"Entreprise"** (ou "Business") -> **"Suivant"**.
5.  Donnez un nom (ex: "Mon API Pubs") et cliquez sur **"Créer l'application"**.

## 🔑 Étape 2 : Obtenir le Token (Graph API Explorer)
C'est le moyen le plus rapide pour tester.

1.  Allez sur l'outil [Graph API Explorer](https://developers.facebook.com/tools/explorer/).
2.  Dans le menu déroulant **"Application"** (à droite), sélectionnez l'app que vous venez de créer.
3.  Cliquez sur **"Obtenir un token"** -> **"Obtenir un User Access Token"**.
4.  **Permissions** : Ajoutez les permissions suivantes (IMPORTANT) :
    *   `pages_read_engagement`
    *   `pages_read_user_content`
    *   `ads_read` (si vous voulez lire les publicités payantes)
5.  Cliquez sur **"Generate Access Token"**.
6.  Validez la fenêtre pop-up de connexion.
7.  **Copiez le Token** qui s'affiche (il est très long).

## 🆔 Étape 3 : Trouver le Page ID
1.  Allez sur votre Page Facebook.
2.  Cliquez sur "À propos" -> "Transparence de la page" OU regardez l'URL.
3.  Plus simple : Dans le [Graph API Explorer](https://developers.facebook.com/tools/explorer/), tapez `me/accounts` et cliquez sur "Submit".
4.  Vous verrez la liste de vos pages avec leur `"id"` et `"access_token"`.

## ⚙️ Étape 4 : Configuration
Ouvrez le fichier `config/config.php` et collez vos informations :

```php
return [
    'app_id' => 'LAISSER_VIDE_SI_TEST',
    'app_secret' => 'LAISSER_VIDE_SI_TEST',
    'access_token' => 'COLLEZ_VOTRE_TOKEN_ICI',
    'page_id' => 'COLLEZ_VOTRE_PAGE_ID_ICI',
    // ...
];
```
