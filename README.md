# spec-HDDT
The Health Device Data Transfer specification enables functionalities for transmitting personal health data from medical devices to DiGAs according to §374a SGB V regulation by providing requirements, FHIR resources, examples, and an implementation guide.

This repository contains the definition of a FHIR Implementation Guide. Compilation is done using:
- [SUSHI](https://fshschool.org/)
- HL7 IG Publisher
- [gematik FHIR IG Template](https://github.com/gematik/fhir-ig-template.git)

The result is a static HTML documentation in the `output/` directory.

## Installation and Compilation

Compilation can be done either manually or via Docker. Manual installation requires Node.js, npm, Sushi, Ruby, and Jekyll. Alternatively, the Docker-based installation can be used, which automatically provides all dependencies in a container.

## Option A: Manual Installation

### System Requirements

1. **Node.js & npm**
    - Installation: [nodejs.org](https://nodejs.org/) (LTS version)
    - Install SUSHI:
      ```powershell
      npm install -g fsh-sushi
      ```

2. **Ruby with DevKit**
    - Installation: [rubyinstaller.org](https://rubyinstaller.org/)
    - Install Jekyll:
      ```powershell
      gem install jekyll bundler
      ```

3. **FHIR IG Template**
   ```powershell
   git clone https://github.com/gematik/fhir-ig-template.git
   ```
   **Important:** The templates must be located in a directory named `fhir-ig-template`, which should be placed alongside this project’s directory.
   ```
   my-projects/
   ├── fhir-ig-template/        # gematik template
   └── hdc-fhir-profiles/       # this project
   ```

### Build Process

1. **Run SUSHI**
   ```powershell
   sushi .
   ```

2. **Initialize FHIR IG Publisher**
   ```powershell
    .\_updatePublisher.bat --yes
    ```

3. **Generate IG**
    ```powershell
    .\_genonce.bat
    ```

### Output and Verification
- The generated documentation is located in the `output/` directory.
- The HTML files can be opened locally in a browser (`output/index.html`) to review the documentation.

## Option B: Docker-based Installation

### System Requirements
- **Docker Desktop** installation: [docker.com](https://www.docker.com/products/docker-desktop/)

### Build Process
1. **Build and deploy the Docker image locally**
   ```powershell
   docker compose up --build
   ```

### Output and Verification
- The generated documentation is accessible in the browser at http://localhost:8081