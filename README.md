###### It is a good idea to add your user to docker group
```
sudo usermod -aG docker your_user_name
```

###### Run
```
docker-compose -f stack.yml build && docker-compose -f stack.yml up -d
```

###### Accessing Wordpress:
`http://localhost:8080`

###### Accessing Adminer:
`http://localhost:4000`
