
docker build -t eac_files docker 
docker run -v %~dp0Build\App:C:\App eac_files