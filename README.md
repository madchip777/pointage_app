# pointage_app

Application Flutter de pointage de presence (connexion, inscription, pointage et historique).

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
- Stockage local via `shared_preferences`

## Partie 3 - Compte rendu obligatoire

Le rendu doit contenir les elements suivants:

- Le projet Flutter complet
- Une capture d'ecran de l'application
- Une capture d'ecran du code montrant les fonctionnalites
- Un document expliquant l'application (objectif, architecture, fonctionnement)

Conseil de structure pour le rendu:

1. Dossier `projet_flutter/` (code source complet)
2. Dossier `captures/` (app + code)
3. Fichier `compte_rendu.pdf` (explications)

## Source

- Cheat sheet Flutter: https://github.com/Temidtech/Flutter-Cheat-Sheet