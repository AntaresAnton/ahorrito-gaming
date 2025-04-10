@echo off
echo Generando estructura de directorios con formato de árbol...
set /p folder=Ingresa la ruta de la carpeta (ej. C:\MiProyecto): 
set /p output=Ingresa la ruta del archivo de salida (ej. C:\estructura.txt): 
echo Estructura de directorios generada el %date% a las %time% > "%output%"
echo. >> "%output%"
tree "%folder%" /f /a >> "%output%"
echo Estructura generada exitosamente en %output%
pause
