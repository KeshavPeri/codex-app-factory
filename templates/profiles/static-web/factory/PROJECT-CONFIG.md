# Project configuration

This profile is a starting point for a static npm web application. Replace placeholders after choosing the framework.

## Stack

- **App type:** Static web application
- **Language/framework:** JavaScript or TypeScript; record the selected framework
- **Package/dependency manager:** npm
- **Data storage:** Record the app-specific choice in the product brief
- **Hosting/deployment:** GitHub Pages

## Commands

- **Install/setup:** `npm ci`
- **Test:** `npm test --if-present`
- **Lint:** `npm run lint --if-present`
- **Build:** `npm run build`
- **Run locally:** Record the actual development command and URL
- **Typecheck or other required check:** Record when applicable

## Local QA

- **Local URL or launch command:** Record after scaffolding
- **Test users or fixtures:** Record app-specific fixtures
- **Important devices/environments:** Current mobile and desktop browsers unless the brief narrows support

## Deployment

- **Preview process:** Local QA evidence by default; add a provider only if the brief requires previews
- **Production trigger:** Merge to `main`
- **Build artifact:** `dist/`
- **Required owner-only setup:** Enable GitHub Pages with GitHub Actions in repository settings
