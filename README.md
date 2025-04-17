# Trial Workspace

## Description

The Trial Workspace is a UI project that the POC team uses to run Trials and Workshops. Use cases of IAP are presented alongside supporting content such as instructions and asset reservation.

## Development

### Prerequisites

- Node.js >= 20.0.0
- npm >= 10.0.0
- CodeClimate CLI (for running CodeClimate analysis)

### Getting Started

1. Clone the trial-workspace repository:

   ```bash
   git clone git@gitlab.com:itential/cloud/trial-workspace.git
   cd trial-workspace
   ```

2. Install dependencies:

   ```bash
   npm install
   ```

3. Place the following in a .env file in the root of the project
   ```
   VITE_CUSTOMER_CONTROL_URL=https://control.tools-dev.itential.io/api/v1
   VITE_KEYCLOAK_CLIENT_ID=hub
   VITE_TOKEN_EXCHANGE_AUDIENCE_CUSTOMER_CONTROL=control
   VITE_KEYCLOAK_URL=https://auth.tools-dev.itential.io
   VITE_HUB_URL=http://localhost:3000
   VITE_ARC_API_GATEWAY_URL=https://arc-inventory.tools-dev.itential.io
   VITE_TRIAL_DATASET_NUMBER=1209
   VITE_IAP_MODELER_URL="https://modeler.tools-dev.itential.io"
   VITE_FEATURE_TRAINING_URL=''
   VITE_GILAB_MODULAR_URL="https://gitlab-markdown.tools-dev.itential.io/"
   ```
4. Start the development server:
   ```bash
   npm run dev
   ```

### Available Scripts

- `npm run dev`: Starts the development server
- `npm run build:tsx`: Builds the project for production
- `npm run lint`: Runs linting checks
- `npm run lint:fix`: Runs linting checks and fixes issues
- `npm run test:unit`: Runs the test suite
- `npm run cc`: Runs CodeClimate analysis
  - Note: This script requires CodeClimate CLI to be installed separately. It is not an npm package. Please refer to the [CodeClimate CLI documentation](https://github.com/codeclimate/codeclimate) for installation instructions.

## Building

To build the project for production, run:

```bash
npm run build:tsx
```

This will create a `dist` folder with the compiled files.

## Testing

To run the test suite, use:

```bash
npm run test:unit
```

## Docker

### Prerequisite

1. Copy `npmrc.example` and make a new `.npmrc` file.
2. Edit the .npmrc file and put your Itential private token where it says INSERT_YOUR_TOKEN_HERE.
3. Work with Itential IT and Cloud Ops to properly setup your access to AWS and local commandline tools. Some instructions can be found in Confluence but they are not complete and/or parts are not applicable for Cloud Dev:
   [link](https://itential.atlassian.net/wiki/spaces/CloudOps/pages/2902556839/AWS+SSO+-+WebConsole+CLI+Setup)

### Building and Pushing the Container Images

1. Verify that your local Docker app is running.
2. Make sure your local configuration is set up properly using the command `npm run config`.
3. Run the build script using the command `npm run build:image` to build prod and dev or `npm run build:dev` for just dev.
4. Use the following command after replacing the image name to deploy the newly built dev image to the dev server `npm_config_tag=REPLACE_IMAGE_NAME npm run deploy`
   Note the dev image name is the package version with -dev, for example `2.20.9-dev` (cloud-ops deploys the prod image).

### running the built server locally (useful to debug the GO server)

`make docker-serve`

## License

This project is licensed under a proprietary license. See the LICENSE file for details.

---

For more information or the latest updates, please refer to the [official repository](https://gitlab.com/itential/cloud/trial-workspace).
