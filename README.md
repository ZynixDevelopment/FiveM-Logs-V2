# Zynix Logs - Script de Monitoring Avancé et Stylé pour FiveM

**Zynix Logs** est un script de monitoring/traçage complet, optimisé pour les serveurs FiveM modernes.  
Il centralise et enrichit les logs du serveur (actions des joueurs, administration, anti-triche, etc.) dans un salon Discord via **webhook**, avec une présentation stylée et des couleurs, pour un suivi clair et efficace.

---

## ✨ Nouveautés de la version 2.0

- **Support ESX & QBCore automatique** (détection du framework au lancement)
- **Logs enrichis** : Affichage Steam, License, Discord, IP, source côté joueur
- **Logs d’actions administratives avancées** : ban, kick, warn, give argent/items/véhicule
- **Logs de crash/mort joueur**
- **Logs de performance** (ping élevé auto-détecté)
- **Mise en forme avancée dans Discord** : embeds colorés, titres, emojis, markdown, horodatage
- **Code optimisé et sécurisé** : anti-spam, facile à étendre, adaptable à d’autres frameworks
- **Facilement personnalisable** pour ajouter vos propres logs ou webhooks
- **Logs métiers, inventaire, argent, véhicules, connexions/déconnexions, commandes, chat, ressources, exploits, etc.**

---

## ⚙️ Dépendances & Compatibilité

- **FiveM** (Windows ou Linux)
- **Discord Webhook** (créez-en un dans le salon voulu)
- **ESX** ou **QBCore** (détection et support automatique)
- Aucune librairie externe n’est requise (utilise les natives FiveM, `json.encode` intégré).

---

## 🛠️ Installation

1. **Placez le dossier dans vos ressources :**  
   Par exemple :  
   ```
   resources/[monitoring]/zynix-logs
   ```

2. **Configurez le webhook Discord :**  
   - Créez un webhook Discord dans le salon de logs.
   - Remplacez la variable dans `server.lua` :
     ```lua
     local webhook = "VOTRE_WEBHOOK_DISCORD_ICI"
     ```

3. **Vérifiez `fxmanifest.lua` :**
   ```lua
   fx_version 'cerulean'
   game 'gta5'

   author 'ZynixDevelopment'
   description 'Script avancé de logs pour FiveM (ESX/QBCore) avec Discord stylé'
   version '2.0.0'

   server_script 'server.lua'
   ```

4. **Ajoutez la ressource à votre `server.cfg` :**
   ```
   ensure zynix-logs
   ```
   > Placez cette ligne **après** votre framework principal :  
   > `ensure es_extended` ou `ensure qb-core`

5. **Redémarrez votre serveur.**

---

## 🚦 Fonctionnement en détail

- **Connexion et détection du framework** : À l’init, le script détecte ESX ou QBCore et adapte automatiquement les logs.
- **Logs joueurs** : Connexion, déconnexion, crash/mort, logs enrichis (Steam, License, Discord, IP, source).
- **Logs chat/commandes** : Tout message ou commande tapée est loggé (filtrage automatique).
- **Logs administration** : Toutes les actions admin (ban/kick/warn/give) sont tracées avec l’admin, la cible, la raison, etc.
- **Logs give** : Don d’argent, items, véhicules, détaillés pour la modération.
- **Logs métiers, inventaire, véhicules** : Changement de job, ajout/retrait d’argent, items, achats de véhicules.
- **Logs des ressources** : Start/stop/restart de chaque ressource.
- **Logs de performance** : Ping auto (tous les joueurs, chaque minute, ping > 180ms).
- **Logs anti-cheat et exploits** : Déclencheurs suspects détectés via events.
- **Logs personnalisés** : Ajoutez vos propres calls à `sendToDiscord`.

Chaque log s’affiche en **embed Discord** : couleur selon type, emoji, titre, horodatage, markdown.

---

## 🎨 Exemple de logs dans Discord

- 🟢 Connexion  
  > **Joueur:** `Zynix`  
  > **Steam:** `steam:110000123456789`  
  > **License:** `license:xxxxxxxx`  
  > **Discord:** <@1234567890>  
  > **IP:** `127.0.0.1`  
  > **Source:** `2`
- 💬 Chat  
  > **[Zynix]** Salut tout le monde !
- ⚙️ Commande  
  > **[Zynix]** `/ban Test`
- ⛔ BAN  
  > **Admin:** `Zynix`  
  > **Joueur:** `Troll`  
  > **Raison:** Cheat  
  > **License:** license:xxxxxxx
- 📦 Ajout Item  
  > **Zynix (steam:110000123456789)**  
  > `+2 pain`
- 🚗 Give Véhicule  
  > **Admin:** `Zynix`  
  > **Joueur:** `VIP`  
  > **Modèle:** `adder`
- 🟢 Ressource Démarrée  
  > `esx_policejob`
- 🏓 Ping élevé  
  > **Zynix**  
  > Ping: `350ms`
- 🚨 Exploit détecté  
  > **Troll**  
  > {"event":"illegal_trigger",...}

---

## 🔧 Personnaliser et étendre

- **Ajouter un log personnalisé** :  
  Ajoute simplement dans ton script :
  ```lua
  sendToDiscord("Titre", "Message markdown", 12345678)
  ```
  (où `12345678` est une couleur Discord en décimal)

- **Ajouter un event QBCore/ESX** :  
  Copie une structure de handler dans `server.lua` et adapte le nom d’event.

- **Filtrer ou désactiver des logs** :  
  Commente/supprime les handlers non voulus dans `server.lua`.

---

## ❓ FAQ & Support

- **Erreur json/cjson** :  
  Si tu as une erreur "json is nil", remplace `json.encode` par `cjson.encode` dans la fonction d’envoi Discord.
- **Logs qui ne remontent pas** :  
  Vérifie l’URL du webhook, la présence du script dans `server.cfg`, et l’ordre de lancement des ressources.
- **Support QBCore/vRP/autre** :  
  Les events QBCore sont déjà intégrés. Pour un autre framework, ajoute tes events dans la même logique.
- **Problème d’affichage Discord** :  
  Vérifie que le bot a accès au salon et que le webhook est valide.

Pour toute demande de logs spécifiques, adaptation, ou bug, ouvre une issue sur GitHub ou contacte ZynixDevelopment sur Discord.

---

## 👨‍💻 Remerciements

Développé par **ZynixDevelopment**.  
Merci à la communauté FiveM pour le feedback et les suggestions !

---
