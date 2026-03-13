@echo off
title Construyendo SAES Cloud (WildFly)
echo ==========================================
echo   Iniciando empaquetado de saes.war...
echo ==========================================

:: 1. Limpiar compilaciones anteriores para evitar errores
if exist build_saes rmdir /S /Q build_saes
if exist saes.war del /Q saes.war

:: 2. Crear la estructura temporal que requiere WildFly
mkdir build_saes
mkdir build_saes\WEB-INF

:: 3. Copiar todos los archivos del frontend a la carpeta temporal
echo [1/3] Copiando archivos web (HTML, CSS, JS)...
copy *.html build_saes\ >nul
copy *.css build_saes\ >nul
copy *.js build_saes\ >nul

:: 4. Generar el archivo web.xml al vuelo para la redireccion del Login
echo [2/3] Generando configuracion web.xml...
(
echo ^<?xml version="1.0" encoding="UTF-8"?^>
echo ^<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee" version="3.1"^>
echo     ^<welcome-file-list^>
echo         ^<welcome-file^>login.html^</welcome-file^>
echo     ^</welcome-file-list^>
echo ^</web-app^>
) > build_saes\WEB-INF\web.xml

:: 5. Empaquetar todo usando la herramienta nativa de Windows
echo [3/3] Ensamblando el archivo saes.war...
cd build_saes
tar.exe -a -c -f ..\saes.war *
cd ..

:: 6. Limpiar la basura temporal
rmdir /S /Q build_saes

echo ==========================================
echo   !LISTO! El archivo saes.war fue creado.
echo ==========================================
echo Siguiente paso: scp saes.war drawy@172.202.104.189:/home/drawy/
pause