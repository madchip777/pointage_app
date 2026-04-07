# pointage_app

Application Flutter de pointage de presence (connexion, inscription, pointage et historique).

![Screenshot page générale](/screenshots/Screenshot1.png)

## Prerequis

- SDK Flutter installe
- Android Studio (SDK Android + emulateur)
- Un device/emulateur configure (exemple: `Medium_Phone_API_36.1`)

## Lancement du projet

1. Lancer l'emulateur:

```bash
flutter emulators --launch Medium_Phone_API_36.1
```

2. Se placer a la racine du projet puis executer:

```bash
flutter pub get
flutter run
```

3. Point d'entree principal:

`lib/main.dart`

## Arbre des chemins (extrait utile)

```text
pointage_app/
|-- lib/
|   |-- main.dart
|   |-- router/
|   |   `-- router.dart
|   |-- connection/
|   |   `-- connection.dart
|   |-- inscription/
|   |   `-- inscription.dart
|   |-- general/
|   |   `-- general.dart
|   |-- accueil/
|   |   `-- accueil.dart
|   |-- pointage/
|   |   |-- pointage.dart
|   |   `-- pointage_repository.dart
|   `-- historique/
|       `-- historique.dart
|-- android/
|-- ios/
|-- web/
|-- linux/
|-- macos/
|-- windows/
`-- pubspec.yaml
```

## Fonctionnalites principales

- Connexion par nom d'employe
- Inscription avec validation des champs
- Enregistrement des pointages (date/heure)
- Historique des presences avec calendrier mensuel visible
- Stockage local simple en memoire (maquette)

## Systeme de conservation des presences

Un systeme simple a ete ajoute pour garder les presences localement sur le device et les rendre accessibles dans toute l'application.

Fichier central:

- `lib/pointage/pointage_repository.dart`

Ce fichier contient:

- `PointageEntry`: modele d'une presence (nom employe, date, heure, timestamp)
- `PointageRepository`: couche unique de lecture/ecriture
- `PointageDuplicateException`: erreur metier si un employe pointe 2 fois le meme jour

Regles de fonctionnement:

- Les presences sont stockees en memoire dans un repository unique
- Une presence maximum par employe et par jour (jour courant)
- Les donnees sont relues depuis le repository pour alimenter les ecrans

Note importante:

- Le stockage en memoire est volontairement simple pour la maquette locale.
- Les donnees sont conservees tant que l'application reste ouverte.
- Si tu fermes/redemarres l'application, les presences repartent a zero.

Distribution dans l'app:

- `lib/general/general.dart`: bouton "Se pointer" -> enregistre via `PointageRepository.enregistrerPointage(...)`
- `lib/pointage/pointage.dart`: enregistrement + affichage des derniers pointages de l'employe
- `lib/historique/historique.dart`: lecture de tous les pointages ou d'un employe, puis affichage calendrier/liste

Ce choix garde le code simple: une seule source de verite pour les presences, reutilisee par toutes les pages qui en ont besoin.

## Partie 3 - Compte rendu obligatoire

Le rendu doit contenir les elements suivants:

- Le projet Flutter complet
- Une capture d'ecran de l'application
- Une capture d'ecran du code montrant les fonctionnalites
- Un document expliquant l'application (objectif, architecture, fonctionnement)

Conseil de structure pour le rendu:

1. Dossier `projet_flutter/` (code source complet)
2. Dossier `lib/` (app + code)

## Source

- Base layout Flutter: https://docs.flutter.dev/ui/layout

- Cheat sheet Flutter: https://github.com/Temidtech/Flutter-Cheat-Sheet