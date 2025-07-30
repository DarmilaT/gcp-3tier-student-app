docker build -t frontend-app .
docker run -p 80:80 --name frontend-container frontend-app 