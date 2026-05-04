#!/bin/bash
set -e # exit on error

# ===== CONFIG =====
PWD_PATH=$(pwd)
WORK_DIR=$([[ "$NODE_ENV" == dev* ]] && dirname "$PWD_PATH" || echo "$PWD_PATH")
MAIN_DIR="000-streams-main"
DIST_DIR="000-streams-dist"
MAIN_REPO_URL="https://$MAIN_AUTH@github.com/$MAIN_REPO.git"
DIST_REPO_URL="https://$DIST_AUTH@github.com/$DIST_REPO.git"

echo $WORK_DIR
echo $MAIN_REPO_URL
echo $DIST_REPO_URL

#
# ===== STEP 1: CLONE MAIN SOURCE CODE =====
echo "Cloning main repository..."
cd $WORK_DIR
rm -rf $MAIN_DIR
git clone "$MAIN_REPO_URL" "$MAIN_DIR"
cd $MAIN_DIR

#
# ===== STEP 2: INSTALL DEPENDENCIES (if needed) =====
if [ -f package.json ]; then
  echo "Installing dependencies..."
  npm install
fi

#
# ===== STEP 3: RUN NODE APP =====
echo "Running application..."
npm run start

#
# ===== STEP 4: CLONE GIST =====
echo "Cloning dist repository..."
cd $WORK_DIR
rm -rf $DIST_DIR
git clone "$DIST_REPO_URL" "$DIST_DIR"

#
# ===== STEP 5: COPY MODIFIED FILES =====
echo "Copying files to dist repo..."
cd $WORK_DIR
cp -vrf "$MAIN_DIR/debug" "$MAIN_DIR/output" "$DIST_DIR/"

#
# ===== STEP 6: COMMIT & PUSH =====
cd $DIST_DIR

git config user.name "4ubox"
git config user.email "go4bigbox@gmail.com"
git add .

if git diff --cached --quiet; then
  echo "No changes to commit."
else
  git commit -m "auto update [$(date -u '+%Y-%m-%d %H:%M:%S UTC')]"

  BRANCH=$(git rev-parse --abbrev-ref HEAD)
  git push -u origin "$BRANCH"
fi

echo "Done!"
