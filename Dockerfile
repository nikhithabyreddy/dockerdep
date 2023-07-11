FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /app

# Copy the package.json file to the container
COPY package.json .

RUN apt-get update && apt-get -y install curl sudo
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get -y install nodejs

# Create a new user
RUN useradd -m -s /bin/bash myuser

# Set the ownership of the application directory to the new user
RUN chown -R myuser:myuser /app/publish

USER myuser

# Copy the rest of the files to the container
COPY . .

RUN dotnet restore

# Run npm install without sudo
RUN npm install --unsafe-perm=true --allow-root

RUN dotnet publish "dotnet6.csproj" -c Release -o /app/publish

# ...
