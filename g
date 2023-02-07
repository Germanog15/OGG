# Copied from https://github.com/facebook/docusaurus/blob/main/.github/workflows/lint.yml
name: Lint

on:
  pull_request:
    branches:
      - main

concurrency:
  group: ${{ github.workflow }}-${{ github.head_ref || github.run_id }}
  cancel-in-progress: true

permissions:
  contents: read

env:
  DATABASE_URL: 'postgresql://postgres:password@localhost:5432/postgres'
  GITHUB_CLIENT_ID: '1234'
  GITHUB_CLIENT_SECRET: 'abcd'
  NEXTAUTH_SECRET: 'efgh'
  NEXTAUTH_URL: 'http://localhost:3000'
  NODE_ENV: test
  SUPABASE_ANON_KEY: 'ijkl'
  SUPABASE_URL: 'https://abcd.supabase.co'

jobs:
  lint:
    name: Lint
    timeout-minutes: 30
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      - name: Set up Node
        uses: actions/setup-node@v3
        with:
          node-version: '16'
          cache: yarn
      - name: Installation
        run: yarn
      - name: Check immutable yarn.lock
        run: git diff --exit-code
      - name: Lint
        run: yarn lint
  6  
apps/portal/src/env/schema.mjs
@@ -4,6 +4,8 @@ import { z } from 'zod';
/**
 * Specify your server-side environment variables schema here.
 * This way you can ensure the app isn't built with invalid env vars.
 *
 * Remember to update existing GitHub workflows that use env vars!
 */
export const serverSchema = z.object({
  DATABASE_URL: z.string().url(),
@@ -20,13 +22,15 @@ export const serverSchema = z.object({
 * Specify your client-side environment variables schema here.
 * This way you can ensure the app isn't built with invalid env vars.
 * To expose them to the client, prefix them with `NEXT_PUBLIC_`.
 *
 * Remember to update existing GitHub workflows that use env vars!
 */
export const clientSchema = z.object({
  // NEXT_PUBLIC_BAR: z.string(),
});

/**
 * You can't destruct `process.env` as a regular object, so you have to do
 * You can't destructure `process.env` as a regular object, so you have to do
 * it manually here. This is because Next.js evaluates this at build time,
 * and only used environment variables are included in the build.
 * @type {{ [k in keyof z.infer<typeof clientSchema>]: z.infer<typeof clientSchema>[k] | undefined }}
