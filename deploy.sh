#!/bin/bash

# ╔══════════════════════════════════════════════════════════════╗
# ║             PORTFOLIO AUTODEPLOY SCRIPT (macOS/Unix)         ║
# ║  Automates: Git Init -> GitHub Repo Creation -> Push -> Pages ║
# ╚══════════════════════════════════════════════════════════════╝

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null
then
    echo "❌ GitHub CLI (gh) could not be found."
    echo "Please install it: 'brew install gh' or download from https://cli.github.com/"
    exit 1
fi

# Check if user is logged in
if ! gh auth status &> /dev/null
then
    echo "❌ You are not logged into GitHub CLI."
    echo "Please run 'gh auth login' first to connect your account."
    exit 1
fi

# Get the repository name (default to current directory name)
CURRENT_DIR=$(basename "$PWD")
echo "Starting deployment for: $CURRENT_DIR"
read -p "Enter a name for your new GitHub repository [default: $CURRENT_DIR]: " input_name
REPO_NAME=${input_name:-$CURRENT_DIR}

# 1. Remove existing remote connection (from the template)
echo "🔗 Removing existing remote connection..."
git remote remove origin 2>/dev/null

# 2. Initialize git if not already
if [ ! -d .git ]; then
    echo "📂 Initializing new Git repository..."
    git init
fi

# 3. Rename branch to main
git branch -M main

# 4. Add and commit changes
echo "💾 Committing files..."
git add .
git commit -m "Initial commit - My Personal Portfolio" --quiet

# 5. Create new repository on GitHub and push
echo "🚀 Creating repository '$REPO_NAME' on your GitHub account..."
gh repo create "$REPO_NAME" --public --source=. --remote=origin --push

if [ $? -eq 0 ]; then
    echo "✅ Repository created and code pushed successfully!"
else
    echo "❌ Failed to create repository. It might already exist on your account."
    exit 1
fi

# 6. Set GitHub Secrets (Automated)
echo "🔐 Setting up EmailJS secrets..."
if [ -f .env ]; then
    # Load from .env if it exists
    source .env 2>/dev/null
fi

# Use variables from .env or ask if empty
PUB_KEY=${EMAILJS_PUBLIC_KEY:-""}
SRV_ID=${EMAILJS_SERVICE_ID:-""}
TMP_ID=${EMAILJS_TEMPLATE_ID:-""}

if [ -z "$PUB_KEY" ]; then read -p "Enter EmailJS Public Key: " PUB_KEY; fi
if [ -z "$SRV_ID" ]; then read -p "Enter EmailJS Service ID: " SRV_ID; fi
if [ -z "$TMP_ID" ]; then read -p "Enter EmailJS Template ID: " TMP_ID; fi

echo "Setting secrets in GitHub..."
gh secret set EMAILJS_PUBLIC_KEY --body "$PUB_KEY"
gh secret set EMAILJS_SERVICE_ID --body "$SRV_ID"
gh secret set EMAILJS_TEMPLATE_ID --body "$TMP_ID"

# 7. Enable GitHub Actions for Deployment
echo "🌐 Configuring GitHub Actions and Pages..."
# Enable Pages with Actions as the source
gh repo edit "$REPO_NAME" --enable-pages --pages-build-type workflow

echo ""
echo "🎉 SUCCESS! Your secrets are set and your deployment is triggered via GitHub Actions."
echo "----------------------------------------------------------"
echo "Your website will be live at: https://$GITHUB_USER.github.io/$REPO_NAME/"
echo "----------------------------------------------------------"
echo "(Note: It may take 1-2 minutes for GitHub to build the page for the first time)"