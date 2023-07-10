FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /app

RUN apt-get update && apt-get -y install curl
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get -y install nodejs

# Create a new user
RUN useradd -m -s /bin/bash myuser

# Set the ownership of the application directory to the new user
RUN chown -R myuser:myuser /app
COPY . ./

USER myuser

RUN dotnet restore

RUN dotnet publish "dotnet6.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
COPY --from=build /app/publish .
ENV ASPNETCORE_URLS http://*:5000

EXPOSE 5000
ENTRYPOINT ["dotnet", "dotnet6.dll"]
