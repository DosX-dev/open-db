@echo off
set envgen=./srv/tools/NecroVM-kgen.exe
set salt=./srv/_nul
set db=./srv/databases/private.NecroVM/users.db

if not exist "%envgen%" exit /b 1

call "%envgen%" -f mode=x16,checksum=d2 -r sha1 -i "%db%" -o "index.txt" -s "%salt%"