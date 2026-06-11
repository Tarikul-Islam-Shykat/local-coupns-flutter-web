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
