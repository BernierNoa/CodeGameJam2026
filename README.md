# Click & Party 🎪

Projet réalisé dans le cadre d'une **Game Jam**, avec le moteur **Godot 4.5** (GDScript).

## Concept

Dans le village de Pointeur-Les-Bains se tient depuis des siècles une grande fête appelée *« Click & Party »*. Alors que les festivités battent leur plein, un **Minotaure** surgit des montagnes, piétine les décors et réduit les stands en miettes avant de disparaître dans la nuit.

Tu incarnes **Clem**, une jeune fille qui a grandi dans le village et n'a jamais manqué une édition de la fête. Grâce à ses souvenirs, elle sait comment tout reconstruire. Ton objectif : enchaîner les mini-jeux de la fête foraine pour réparer chaque stand détruit par le Minotaure, avant d'affronter une dernière course contre lui.

## Mini-jeux

- **Course du Minotaure** — Le Minotaure te poursuit sur 500 mètres. Clique le plus vite possible pour accélérer et distancer la bête avant qu'elle ne te rattrape (plusieurs phases de vitesse croissante).
- **Gobelets (bonneteau)** — Repère sous quel gobelet se cache la balle après le mélange. La difficulté (nombre de gobelets, vitesse et nombre d'échanges) augmente avec le score.
- **Jonglage** — Clique sur les balles pour les garder en l'air le plus longtemps possible sans en perdre une seule.
- **Pop the Balloon** — Mini-jeu d'adresse pour faire éclater les ballons du stand.
- **Sandbox** — Une scène bac à sable pour tester librement les mécaniques du jeu.

## Contrôles

| Action | Touche |
|---|---|
| Avancer / accélérer (course) | `D`, clic gauche ou bouton/joystick droit (`ui_right`) |
| Interagir | `E` |
| Cliquer / sélectionner (mini-jeux) | Clic gauche de la souris |

Le jeu prend aussi en charge une manette (boutons et joystick).

## Comment ouvrir le projet dans Godot

1. Installer [Godot 4.5](https://godotengine.org/download) (version *Forward Plus*).
2. Cloner ce dépôt :
   ```bash
   git clone https://github.com/BernierNoa/CodeGameJam2026.git
   ```
3. Ouvrir Godot, cliquer sur **Importer**, puis sélectionner le fichier `project.godot` à la racine du dépôt.
4. Lancer le projet avec `F5` (scène principale : le menu d'accueil).

## Structure du projet

- `main_menu.tscn` / `main_menu.gd` — Menu principal (Jouer, Sandbox, Crédits, Paramètres).
- `introduction.tscn` / `introduction.gd` — Cinématique d'introduction narrant l'histoire.
- `CourseMinotaure.tscn` / `game_manager.gd` / `joueur.gd` / `minotaure.gd` — Course-poursuite finale contre le Minotaure.
- `gobelet_game.tscn` / `gobelet_game.gd` — Mini-jeu des gobelets.
- `juggles.tscn` / `juggles.gd` / `balle.gd` — Mini-jeu de jonglage.
- `PopTheBallon.tscn` — Mini-jeu des ballons.
- `map.tscn` — Carte du village reliant les différents stands/mini-jeux.
- `sandbox.tscn` / `sandbox.gd` — Scène de test.
