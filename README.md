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


## License

Copyright 2025 gematik GmbH

Apache License, Version 2.0

See the [LICENSE](./LICENSE) for the specific language governing permissions and limitations under the License

## Additional Notes and Disclaimer from gematik GmbH

1. Copyright notice: Each published work result is accompanied by an explicit statement of the license conditions for use. These are regularly typical conditions in connection with open source or free software. Programs described/provided/linked here are free software, unless otherwise stated.
2. Permission notice: Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
    1. The copyright notice (Item 1) and the permission notice (Item 2) shall be included in all copies or substantial portions of the Software.
    2. The software is provided "as is" without warranty of any kind, either express or implied, including, but not limited to, the warranties of fitness for a particular purpose, merchantability, and/or non-infringement. The authors or copyright holders shall not be liable in any manner whatsoever for any damages or other claims arising from, out of or in connection with the software or the use or other dealings with the software, whether in an action of contract, tort, or otherwise.
    3. The software is the result of research and development activities, therefore not necessarily quality assured and without the character of a liable product. For this reason, gematik does not provide any support or other user assistance (unless otherwise stated in individual cases and without justification of a legal obligation). Furthermore, there is no claim to further development and adaptation of the results to a more current state of the art.
3. Gematik may remove published results temporarily or permanently from the place of publication at any time without prior notice or justification.
4. Please note: Parts of this code may have been generated using AI-supported technology. Please take this into account, especially when troubleshooting, for security analyses and possible adjustments.
