#!/bin/bash

# ╔══════════════════════════════════════════════════════════════╗
# ║             PORTFOLIO AUTODEPLOY SCRIPT (macOS/Unix)         ║
# ║  Automates: Git Init -> GitHub Repo Creation -> Push -> Pages ║
# ╚══════════════════════════════════════════════════════════════╝

SKIP_EMAILJS_SECRETS=false
for arg in "$@"; do
    if [ "$arg" = "--skip-secrets" ]; then
        SKIP_EMAILJS_SECRETS=true
    fi
done

# Allow non-interactive skipping via environment variable as well.
if [ "${SKIP_EMAILJS_SECRETS:-}" = "1" ] || [ "${SKIP_EMAILJS_SECRETS:-}" = "true" ]; then
    SKIP_EMAILJS_SECRETS=true
fi

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

# 5. Create repo if needed, otherwise connect and push
GITHUB_USER=$(gh api user -q .login)
FULL_REPO="$GITHUB_USER/$REPO_NAME"

if gh repo view "$FULL_REPO" >/dev/null 2>&1; then
    echo "📂 Repository '$FULL_REPO' already exists. Connecting and pushing..."
    git remote add origin "https://github.com/$FULL_REPO.git" 2>/dev/null || true
    git push -u origin main
else
    echo "🚀 Creating repository '$FULL_REPO' on your GitHub account..."
    gh repo create "$FULL_REPO" --public --source=. --remote=origin --push
fi

if [ $? -eq 0 ]; then
    echo "✅ Repository synchronized successfully!"
else
    echo "❌ Failed to synchronize repository with GitHub."
    exit 1
fi

# 6. Set GitHub Secrets (Automated)
if [ "$SKIP_EMAILJS_SECRETS" = true ]; then
    echo "⏭️  Skipping EmailJS secret setup (--skip-secrets enabled)."
else
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
    gh secret set EMAILJS_PUBLIC_KEY --repo "$FULL_REPO" --body "$PUB_KEY"
    gh secret set EMAILJS_SERVICE_ID --repo "$FULL_REPO" --body "$SRV_ID"
    gh secret set EMAILJS_TEMPLATE_ID --repo "$FULL_REPO" --body "$TMP_ID"
fi

# 7. Trigger deployment using workflow in repository
echo "🌐 GitHub Actions workflow will handle Pages deployment..."

echo ""
if [ "$SKIP_EMAILJS_SECRETS" = true ]; then
    echo "🎉 SUCCESS! Deployment is triggered via GitHub Actions (EmailJS secrets skipped)."
else
    echo "🎉 SUCCESS! Your secrets are set and your deployment is triggered via GitHub Actions."
fi
echo "----------------------------------------------------------"
echo "Your website will be live at: https://$GITHUB_USER.github.io/$REPO_NAME/"
echo "----------------------------------------------------------"
echo "(Note: It may take 1-2 minutes for GitHub to build the page for the first time)"