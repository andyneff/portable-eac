
docker build -t eac_files docker 
docker run -it --rm -v %~dp0App:C:\App eac_files