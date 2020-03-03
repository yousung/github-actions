name: CI Build

on: [pull_request]

jobs:
  build:
    runs-on: ubuntu-latest

    strategy:
      matrix:
        node-version: [12.x]

    steps:
      - uses: actions/checkout@v1

      - name: Use Node.js ${{ matrix.node-version }}
        uses: actions/setup-node@v1
        with:
          node-version: ${{ matrix.node-version }}
          registry-url: "https://npm.pkg.github.com"

      - name: Set up SSH Agent
        uses: webfactory/ssh-agent@v0.1.1
        with:
          ssh-private-key: ${{ secrets.SSH_PRIVATE_KEY }}

      - name: Install dependencies
        run: yarn install
        env:
          NODE_AUTH_TOKEN: ${{ secrets.GPR_AUTH_TOKEN }}
          CI: true

      - name: Run Build
        run: yarn build

      - name: Run Tests
        run: yarn run test:ci
