# Étape de build
FROM golang:1.16-alpine as builder

# Définir le répertoire de travail dans le conteneur
WORKDIR /app

# Copier les fichiers go.mod et go.sum
COPY go.mod ./
COPY go.sum ./

# Télécharger les dépendances
RUN go mod download

# Copier le reste des fichiers sources du projet
COPY . .

# Compiler l'application
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /main .

# Étape de l'image finale
FROM scratch

# Copier le binaire compilé de l'étape de build
COPY --from=builder /main /main

# Définir le port sur lequel l'application va écouter
EXPOSE 8080

# Définir la commande pour exécuter l'application
CMD ["/main"]
