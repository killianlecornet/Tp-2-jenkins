# Étape de build
FROM golang:1.16-alpine as builder

# Définir le répertoire de travail dans le conteneur
WORKDIR /app

# Copier les fichiers de dépendances pour mieux utiliser le cache des couches Docker
# Ici, on suppose que go.mod et go.sum sont dans le dossier jk-golang-webapp-books-main
COPY jk-golang-webapp-books-main/go.mod jk-golang-webapp-books-main/go.sum ./

# Télécharger les dépendances
RUN go mod download

# Copier le reste des fichiers sources du projet
# Ici, on copie le contenu du sous-dossier jk-golang-webapp-books-main dans le répertoire de travail
COPY jk-golang-webapp-books-main/ ./

# Compiler l'application
# La commande de build utilise '.' pour construire le fichier binaire à partir des fichiers du répertoire de travail
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o main .

# Étape de l'image finale
FROM scratch

# Copier le binaire compilé de l'étape de build dans l'image scratch
COPY --from=builder /app/main /main

# Définir le port sur lequel l'application va écouter
EXPOSE 8080

# Définir la commande pour exécuter l'application
CMD ["/main"]
