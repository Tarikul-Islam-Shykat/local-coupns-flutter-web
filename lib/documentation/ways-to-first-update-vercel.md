# Ways To First Update Vercel

Use this checklist when the Flutter web app works locally but Vercel shows `404: NOT_FOUND`, a blank page, or an old deploy.

## 1. Confirm the repo is pushing the right branch

- Make sure Vercel is connected to the same GitHub repository.
- Check that the deployment is watching the branch you actually push to, usually `main`.
- Confirm the latest commit is visible in GitHub.

## 2. Confirm the project root in Vercel

- The project root should point to the repo root.
- Do not point Vercel at a subfolder unless the whole app is inside that folder.
- For this project, the root should contain:
  - `pubspec.yaml`
  - `lib/`
  - `web/`
  - `vercel.json`

## 3. Confirm the build output exists

Flutter web must be built before Vercel can serve it.

- Check that `build/web` exists after running the build.
- Check that it contains:
  - `index.html`
  - `main.dart.js`
  - `flutter_bootstrap.js`
  - `assets/`
  - `canvaskit/`

If those files are missing, the site will not load correctly.

## 4. Confirm the Vercel config

This repo uses `vercel.json` to tell Vercel where the static web files live.

Expected setup:

- `outputDirectory` should be `build/web`
- rewrites should send app routes to `/index.html`

If Vercel is showing `404`, check that `vercel.json` is committed and deployed.

## 5. Confirm Flutter web builds cleanly

Before pushing changes, run:

```bash
flutter analyze
flutter build web --release
```

If either command fails, fix the code before expecting Vercel to work.

## 5.1 Recommended pre-push checklist

Run these steps every time before you push to GitHub:

1. Format the code

```bash
dart format .
```

2. Check for issues

```bash
flutter analyze
```

3. Build the release web app

```bash
flutter build web --release
```

4. Commit your changes

```bash
git add .
git commit -m "your message"
```

5. Push to GitHub

```bash
git push
```

Why this matters:

- `flutter build web --release` makes sure Vercel gets a fresh production build.
- If you skip the release build, Vercel may deploy an older or incomplete web output.
- If you change routes, auth, or dashboard pages, the release build is the safest check before pushing.

## 6. What to fix if Vercel shows 404

If the site deploys but the page still shows `404: NOT_FOUND`, fix these in order:

1. Check that the deploy is the newest commit.
2. Check that the deployment root is the repo root.
3. Check that `build/web/index.html` exists in the deployed files.
4. Check that `vercel.json` points to `build/web`.
5. Check that routes are rewritten to `/index.html`.
6. If needed, redeploy from Vercel after clearing cache.

## 7. What to fix if the page is blank

- Check the browser console for JavaScript errors.
- Confirm `main.dart.js` loaded successfully.
- Confirm `web/index.html` still references `flutter_bootstrap.js`.
- Make sure the app code does not have a compile error.

## 8. What to fix if the page is old

- Push the latest code to the correct branch.
- Trigger a fresh Vercel redeploy.
- Clear the Vercel build cache if it keeps serving stale output.

## 9. Quick handoff note for another person or AI

If you want someone else to fix Vercel, send this:

> Please check the Flutter web Vercel deployment. Verify the project root, `vercel.json`, and the `build/web` output. If the site is returning `404: NOT_FOUND`, make sure Vercel is serving `build/web` and rewriting routes to `/index.html`. Also confirm the latest commit is deployed.

## 10. Fast checklist

- `flutter analyze` passes
- `flutter build web --release` passes
- `build/web` exists
- `vercel.json` exists
- Vercel points to the repo root
- `outputDirectory` is `build/web`
- routes rewrite to `/index.html`

## 11. Keep this in mind

For Flutter web, Vercel is usually just a static file host. The important part is not the Dart source itself, but the generated `build/web` folder and the config that tells Vercel how to serve it.

If the code looks updated locally but Vercel still shows old behavior, the first thing to verify is whether `flutter build web --release` was run before the push.

## 12. Login returns `null` in Flutter web

If login works in Postman but Flutter web shows `null`, check CORS first.

What happened in this project:

- The backend login endpoint returned `200 OK` in `curl` and Postman.
- The browser still blocked the response because `Access-Control-Allow-Origin` was missing.
- The backend had `Access-Control-Allow-Credentials: true`, so it needed to explicitly allow the frontend origin.

What to fix:

- Allow the Flutter local origin during development.
- Allow the Vercel frontend origin in production.
- Make sure `OPTIONS` preflight is handled.
- Return `Access-Control-Allow-Origin` for the allowed origin, not `*`, when credentials are enabled.

How to recognize it:

- The request payload prints in Flutter logs.
- The response becomes `null`.
- Chrome DevTools may show a CORS or `Failed to fetch` message.
- `curl` and Postman still work.

Short note to send to backend dev:

> Flutter web is hitting a CORS block. Postman works, but Chrome gets `null` because the response does not include `Access-Control-Allow-Origin` for the Flutter origin. Please whitelist the local Flutter origin and the Vercel frontend domain, and make sure preflight `OPTIONS` is handled.

## 13. Dashboard loads but users load differently

If the users list works but the dashboard overview still says it cannot be loaded, check whether the dashboard request is actually sending the bearer token.

What happened in this project:

- Login returns a JSON token.
- The `/users` endpoint works with a bearer token in the `Authorization` header.
- The dashboard can fail if the request is forced into cookie auth and skips the bearer token.

What to fix:

- Make sure the dashboard request sends `Authorization: Bearer <token>`.
- Check the Support tab to confirm the token exists in storage.
- Check the debug log to confirm the dashboard request is using `Bearer auth`.

How to recognize it:

- `/users` works in Flutter web.
- `/admindashboards` says unauthorized.
- The Support log shows `Bearer token: not sent` or `sendBearerToken=false`.

Admin navigation note:

- The all-user list lives in the sidebar tab labeled `Users`.
- That tab opens the same user-management screen, which can filter by consumer or merchant role.


