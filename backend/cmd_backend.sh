docker build -t backend-app .
docker run -p 3500:3500 --env-file .env --name backend-container backend-app 
