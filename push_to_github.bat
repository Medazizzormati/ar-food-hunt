@echo off
echo Creating a new branch...
git checkout -b feature/real-map-api

echo Staging all files...
git add .

echo Committing changes...
git commit -m "feat: Replace static mock data with real API integration and OpenStreetMap"

echo Pushing to GitHub...
git push -u origin feature/real-map-api

echo.
echo ==============================================================
echo Done! Your changes have been pushed to GitHub.
echo ==============================================================
pause
