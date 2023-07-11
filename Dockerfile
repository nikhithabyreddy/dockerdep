FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
RUN groupadd -r myuser && useradd -r -g myuser myuser

WORKDIR /app

RUN apt-get update
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get -y install nodejs

# Copy the project files to the container
COPY . .
RUN groupadd -r myuser && useradd -r -g myuser myuser
USER myuser
# Restore dependencies
RUN dotnet restore
RUN dotnet bulid "dotnet6.csproj" -c Release
# Build and publish the application
RUN dotnet publish "dotnet6.csproj" -c Release -o /app/publish

# Set permissions for user


# Start a new stage for the runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
RUN useradd -ms /bin/bash/myuser
WORKDIR /app

# Copy the published output from the build stage
COPY --from=build /app/publish .

# Set the environment variable for ASP.NET Core URL binding
ENV ASPNETCORE_URLS http://*:5000

# Expose the port
EXPOSE 5000

# Set the entry point to start the application
ENTRYPOINT ["dotnet", "dotnet6.dll"]
