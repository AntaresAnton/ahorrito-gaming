@echo off
echo Generando estructura de directorios desde la carpeta actual...
set output=estructura_%date:~-4,4%%date:~-7,2%%date:~-10,2%.txt
echo Estructura de directorios generada el %date% a las %time% > "%output%"
echo. >> "%output%"
echo === ESTRUCTURA DE ÁRBOL === >> "%output%"
tree /f /a >> "%output%"
echo. >> "%output%"
echo === LISTADO DETALLADO === >> "%output%"
dir /s /b /a | sort >> "%output%"
echo Estructura generada exitosamente en %cd%\%output%
pause
