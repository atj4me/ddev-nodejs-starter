#!/usr/bin/env bats

# Bats is a testing framework for Bash
# Documentation https://bats-core.readthedocs.io/en/stable/
# Bats libraries documentation https://github.com/ztombol/bats-docs

# For local tests, install bats-core, bats-assert, bats-file, bats-support
# And run this in the add-on root directory:
#   bats ./tests/test.bats
# To exclude release tests:
#   bats ./tests/test.bats --filter-tags '!release'
# For debugging:
#   bats ./tests/test.bats --show-output-of-passing-tests --verbose-run --print-output-on-failure

setup() {
  set -eu -o pipefail

  # Override this variable for your add-on:
  export GITHUB_REPO=atj4me/ddev-nodejs-starter

  TEST_BREW_PREFIX="$(brew --prefix 2>/dev/null || true)"
  export BATS_LIB_PATH="${BATS_LIB_PATH}:${TEST_BREW_PREFIX}/lib:/usr/lib/bats"
  bats_load_library bats-assert
  bats_load_library bats-file
  bats_load_library bats-support

  export DIR="$(cd "$(dirname "${BATS_TEST_FILENAME}")/.." >/dev/null 2>&1 && pwd)"
  export PROJNAME="test-$(basename "${GITHUB_REPO}")"
  mkdir -p ~/tmp
  export TESTDIR=$(mktemp -d ~/tmp/${PROJNAME}.XXXXXX)
  export DDEV_NONINTERACTIVE=true
  export DDEV_NO_INSTRUMENTATION=true
  ddev delete -Oy "${PROJNAME}" >/dev/null 2>&1 || true
  cd "${TESTDIR}"
  
  # Create a minimal Node.js project for testing
  echo '{"name": "test-nodejs-app", "version": "1.0.0", "scripts": {"build": "mkdir -p dist && echo \"<h1>Hello Node.js</h1>\" > dist/index.html", "dev": "echo \"Dev server would start here\""}}' > package.json
  mkdir -p src
  echo "console.log('Hello Node.js');" > src/index.js
  
  run ddev config --project-name="${PROJNAME}" --project-tld=ddev.site
  assert_success
  run ddev start -y
  assert_success
}

health_checks() {
  # Check that the addon files were installed
  assert_file_exists .ddev/config.nodejs.yaml
  assert_file_exists .ddev/docker-compose.nodejs.yaml
  
  # Check that the main config.yaml was created or updated
  assert_file_exists .ddev/config.yaml
  
  # Check that Node.js configuration is present
  run grep -q "nodejs_version" .ddev/config.yaml
  assert_success
  
  # Check that the docroot is set to dist
  run grep -q "docroot: dist" .ddev/config.yaml
  assert_success
  
  # Check that the site is accessible
  run curl -sf https://${PROJNAME}.ddev.site
  assert_success
  
  # Check for Node.js-specific DDEV configuration
  run ddev describe
  assert_success
  assert_output --partial "nodejs"
  
  # Verify that npm install runs successfully
  run ddev exec npm install
  assert_success
  
  # Verify that build command works
  run ddev exec npm run build
  assert_success
  
  # Check that dist directory was created and contains built files
  assert_file_exists dist/index.html
  
  # Check that the built file is served
  run curl -sf https://${PROJNAME}.ddev.site/
  assert_success
  assert_output --partial "Hello Node.js"
}

teardown() {
  set -eu -o pipefail
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1
  # Persist TESTDIR if running inside GitHub Actions. Useful for uploading test result artifacts
  # See example at https://github.com/ddev/github-action-add-on-test#preserving-artifacts
  if [ -n "${GITHUB_ENV:-}" ]; then
    [ -e "${GITHUB_ENV:-}" ] && echo "TESTDIR=${HOME}/tmp/${PROJNAME}" >> "${GITHUB_ENV}"
  else
    [ "${TESTDIR}" != "" ] && rm -rf "${TESTDIR}"
  fi
}

@test "install from directory" {
  set -eu -o pipefail
  echo "# ddev add-on get ${DIR} with project ${PROJNAME} in $(pwd)" >&3
  run ddev add-on get "${DIR}"
  assert_success
  run ddev restart -y
  assert_success
  health_checks
}

# bats test_tags=release
@test "install from release" {
  set -eu -o pipefail
  echo "# ddev add-on get ${GITHUB_REPO} with project ${PROJNAME} in $(pwd)" >&3
  run ddev add-on get "${GITHUB_REPO}"
  assert_success
  run ddev restart -y
  assert_success
  health_checks
}