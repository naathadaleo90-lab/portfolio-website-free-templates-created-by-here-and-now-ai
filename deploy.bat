@echo off
setlocal enabledelayedexpansion

set "SKIP_EMAILJS_SECRETS=%SKIP_EMAILJS_SECRETS%"
for %%A in (%*) do (
    if /I "%%~A"=="--skip-secrets" set "SKIP_EMAILJS_SECRETS=true"
)
if /I "!SKIP_EMAILJS_SECRETS!"=="1" set "SKIP_EMAILJS_SECRETS=true"

:: ╔══════════════════════════════════════════════════════════════╗
:: ║            PORTFOLIO AUTODEPLOY SCRIPT (Windows)           ║
:: ║  Automates: Git Init -> GitHub Repo Creation -> Push -> Pages ║
:: ╚══════════════════════════════════════════════════════════════╝

:: Check if GitHub CLI is installed
where gh >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo ❌ GitHub CLI (gh) could not be found.
    echo Please install it from: https://cli.github.com/
    pause
    exit /b 1
)

:: Check if user is logged in
gh auth status >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo ❌ You are not logged into GitHub CLI.
    echo Please run "gh auth login" first to connect your account.
    pause
    exit /b 1
)

:: Get the repository name (default to current directory name)
for %%I in (.) do set "DEFAULT_REPO_NAME=%%~nxI"
echo Starting deployment for: !DEFAULT_REPO_NAME!
set /p "REPO_NAME=Enter a name for your new GitHub repository [default: !DEFAULT_REPO_NAME!]: "
if "!REPO_NAME!"=="" set "REPO_NAME=!DEFAULT_REPO_NAME!"

:: 1. Remove existing remote connection (from the template)
echo 🔗 Removing existing remote connection...
git remote remove origin 2>nul

:: 2. Initialize git if not already
if not exist .git (
    echo 📂 Initializing new Git repository...
    git init
)

:: 3. Rename branch to main
git branch -M main

:: 4. Add and commit changes
echo 💾 Committing files...
git add .
git commit -m "Initial commit - My Personal Portfolio" --quiet

:: 5. Create repo if needed, otherwise connect and push
for /f "tokens=*" %%a in ('gh api user -q .login') do set "GITHUB_USER=%%a"
set "FULL_REPO=!GITHUB_USER!/!REPO_NAME!"

gh repo view "!FULL_REPO!" >nul 2>nul
if !ERRORLEVEL! equ 0 (
    echo 📂 Repository "!FULL_REPO!" already exists. Connecting and pushing...
    git remote add origin "https://github.com/!FULL_REPO!.git" 2>nul
    git push -u origin main
) else (
    echo 🚀 Creating repository "!FULL_REPO!" on your GitHub account...
    gh repo create "!FULL_REPO!" --public --source=. --remote=origin --push
)

if !ERRORLEVEL! neq 0 (
    echo ❌ Failed to synchronize repository with GitHub.
    pause
    exit /b 1
)

echo ✅ Repository synchronized successfully!

:: 6. Set GitHub Secrets (Automated)
if /I "!SKIP_EMAILJS_SECRETS!"=="true" (
    echo Skipping EmailJS secret setup (--skip-secrets enabled).
) else (
    echo 🔐 Setting up EmailJS secrets...
    if exist .env (
        for /f "tokens=1,2 delims==" %%i in (.env) do set "%%i=%%j"
    )

    :: Use variables from .env or ask if empty
    if "!EMAILJS_PUBLIC_KEY!"=="" set /p "EMAILJS_PUBLIC_KEY=Enter EmailJS Public Key: "
    if "!EMAILJS_SERVICE_ID!"=="" set /p "EMAILJS_SERVICE_ID=Enter EmailJS Service ID: "
    if "!EMAILJS_TEMPLATE_ID!"=="" set /p "EMAILJS_TEMPLATE_ID=Enter EmailJS Template ID: "

    echo Setting secrets in GitHub...
    gh secret set EMAILJS_PUBLIC_KEY --repo "!FULL_REPO!" --body "!EMAILJS_PUBLIC_KEY!"
    gh secret set EMAILJS_SERVICE_ID --repo "!FULL_REPO!" --body "!EMAILJS_SERVICE_ID!"
    gh secret set EMAILJS_TEMPLATE_ID --repo "!FULL_REPO!" --body "!EMAILJS_TEMPLATE_ID!"
)

:: 7. Trigger deployment using workflow in repository
echo 🌐 GitHub Actions workflow will handle Pages deployment...

echo.
if /I "!SKIP_EMAILJS_SECRETS!"=="true" (
    echo 🎉 SUCCESS! Deployment is triggered via GitHub Actions (EmailJS secrets skipped).
) else (
    echo 🎉 SUCCESS! Your secrets are set and your deployment is triggered via GitHub Actions.
)
echo ----------------------------------------------------------
echo Your website will be live at: https://!GITHUB_USER!.github.io/!REPO_NAME!/
echo ----------------------------------------------------------
echo (Note: It may take 1-2 minutes for GitHub to build the page for the first time)
pause
