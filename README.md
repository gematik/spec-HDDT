<!-- TOC -->
* [FHIR Implementation Guide (IG) Projekt](#fhir-implementation-guide-ig-projekt)
  * [Installation und Kompilierung](#installation-und-kompilierung)
  * [Option A: Manuelle Installation](#option-a-manuelle-installation)
    * [Systemvoraussetzungen](#systemvoraussetzungen)
    * [Build-Prozess](#build-prozess)
    * [Ausgabe und Verifikation](#ausgabe-und-verifikation)
  * [Option B: Docker-basierte Installation](#option-b-docker-basierte-installation)
    * [Systemvoraussetzungen](#systemvoraussetzungen-1)
    * [Build-Prozess](#build-prozess-1)
    * [Ausgabe und Verifikation](#ausgabe-und-verifikation-1)
<!-- TOC -->

# FHIR Implementation Guide (IG) Projekt

Dieses Repository beinhaltet die Definition eines FHIR Implementation Guides. Die Kompilierung erfolgt mittels:
- [SUSHI](https://fshschool.org/)
- HL7 IG Publisher
- [gematik FHIR IG Template](https://github.com/gematik/fhir-ig-template.git)

Das Ergebnis ist eine statische HTML-Dokumentation im `output/`-Verzeichnis.

## Installation und Kompilierung

Die Kompilierung kann entweder manuell oder via Docker durchgeführt werden. Die manuelle Installation erfordert Node.js, npm, Sushi, Ruby und Jekyll. Alternativ kann die Docker-basierte Installation verwendet werden, die alle Abhängigkeiten automatisch in einem Container bereitstellt.

## Option A: Manuelle Installation

### Systemvoraussetzungen

1. **Node.js & npm**
    - Installation: [nodejs.org](https://nodejs.org/) (LTS-Version)
    - SUSHI installieren:
      ```powershell
      npm install -g fsh-sushi
      ```

2. **Ruby mit DevKit**
    - Installation: [rubyinstaller.org](https://rubyinstaller.org/)
    - Jekyll installieren:
      ```powershell
      gem install jekyll bundler
      ```

3. **FHIR IG Template**
   ```powershell
   git clone https://github.com/gematik/fhir-ig-template.git
   ```
   **Wichtig:** Die Templates müssen im Verzeichnis namens `fhir-ig-template` liegen, welches parallel zum Verzeichnis dieses Projektes liegt.
   ```
   meine-projekte/
   ├── fhir-ig-template/        # gematik-Template
   └── hdc-fhir-profiles/       # dieses Projekt
   ```
   
### Build-Prozess

1. **SUSHI ausführen**
   ```powershell
   sushi .
   ```
   
2. **FHIR IG Publisher initialisieren**
   ```powershell
    .\_updatePublisher.bat --yes
    ```
   
3. **IG generieren**
    ```powershell
    .\_genonce.bat
    ```
   
### Ausgabe und Verifikation
- Die generierte Dokumentation befindet sich im Verzeichnis `output/`.
- Die HTML-Dateien können lokal im Browser geöffnet werden (`output/index.html`), um die Dokumentation zu überprüfen.
   
## Option B: Docker-basierte Installation
### Systemvoraussetzungen
- **Docker-Desktop** Installation: [docker.com](https://www.docker.com/products/docker-desktop/)

### Build-Prozess
1. **Docker-Image bauen und lokal deployen**
   ```powershell
   docker compose up --build
   ```
   
### Ausgabe und Verifikation
- Die generierte Dokumentation ist im Browser unter http://localhost:8081 erreichbar.