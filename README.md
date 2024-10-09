# Corretto run environment for Platforma Backend

This package is the catalogue of all supported versions of 'corretto' run environment.

Unlike most other software packages, it keeps software descriptors for all corretto versions
published earlier.

As we do not maintain/build our own java, the version of this package is not bound to any
specific version of amazon corretto distribution, but newer corretto version publications
produce newer software descriptors in this package.

## How to release new version of corretto run environment

1. Update `package.json`:
   1. Add new entrypoint for fresh version of java.
   2. Change version of java built by default in CI (`pkg:build` and `publish:packages` scripts).
2. Run build script to check packages and descriptors are built normally
  ```bash
  npm run pkg:build
  ```
1. Commit new descriptor generated in `dist` directory.
2. Bump `<minor>` version part in `package.json`.
