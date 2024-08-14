# Corretto run environment for Platforma Backend

This package is the catalogue of all supported versions of 'corretto' run environment.

Unlike most other software packages, it keeps software descriptors for all corretto versions
published earlier.

As we do not maintain/build our own java, the version of this package is not bound to any
specific version of amazon corretto distribution, but newer corretto version publications
produce newer software descriptors in this package.

## How to release new version of corretto run environment

1. Render environment descriptor for new version of corretto and check it can be downloaded and repacked:
  ```bash
  npm run pkg:build <corretto version> # e.g. npm run pkg:build 21.0.2.13.1
  ```
2. Commit the descriptor generated in `dist` directory
3. Update `package.json`, changing target version in `release:packages` script
4. Bump `<minor>` version part in `package.json`
