@echo off
cd /d "%~dp0"
echo Lancement de Memoire coutumiere...
echo.
echo Adresse a ouvrir dans le navigateur :
echo http://127.0.0.1:8765
echo.
echo Garde cette fenetre ouverte pendant l'utilisation.
echo Pour arreter l'application, ferme cette fenetre ou appuie sur Ctrl+C.
echo.
"C:\Users\chris\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe" app.py
pause
