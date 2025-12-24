# Packaged Frontend - Technical Visit

This folder contains the production-ready build of the Technical Visit application frontend.

## 🚀 Quick Start

1.  **Install Node.js**: Make sure you have Node.js (v18+) installed.
2.  **Install dependencies**:
    ```bash
    npm install
    ```
3.  **Start the server**:
    ```bash
    npm start
    ```
4.  **Open the app**: Navigate to `http://localhost:4200` in your browser.

## ⚙️ Configuration

- **Port**: By default, the server runs on port 4200. You can change this by setting the `PORT` environment variable:
  ```bash
  PORT=8080 npm start
  ```
- **API URL**: If you need to change the backend API URL, you must rebuild the Angular project with the updated environment file before packaging.
