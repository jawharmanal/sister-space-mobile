# 🌸 Sister Space — Application mobile Flutter

App mobile en Flutter (web + mobile) connectée à ton back-end Railway.

## 7 écrans
1. 🔐 Welcome / Login (connecté API)
2. 🏠 Home Feed avec onglets ronds (connecté API)
3. ➕ Create Post (connecté API)
4. 💬 Messages — liste (visuel)
5. 💭 Chat thread (visuel)
6. 👤 Profile (utilisatrice connectée)
7. 🔍 Explore — catégories (visuel)

## 📱 Cadre téléphone
Sur écran large (web Chrome), l'app s'affiche dans un cadre simulé style iPhone.
Sur petit écran ou mobile natif, elle prend tout l'écran.

## 🚀 Lancer
```bash
flutter pub get
flutter run -d chrome
```

## 📝 Notes
- Le login, le feed et la création de post sont **connectés** à ton API.
- Messages, Chat, Explore sont des **maquettes visuelles** : il faudra
  brancher les services back pour les rendre fonctionnels (envoie-moi
  `message.service.ts` pour la suite).
