# Étape de build
FROM golang:1.16-alpine as builder

# Définir le répertoire de travail dans le conteneur
WORKDIR /Tp-2-jenkins

# Copier les fichiers de dépendances pour mieux utiliser le cache des couches Docker
COPY go.mod go.sum ./

# Télécharger les dépendances et nettoyer les modules
RUN go mod download && go mod tidy

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
