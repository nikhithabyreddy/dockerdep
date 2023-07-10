FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /app

RUN apt-get update
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get -y install nodejs

# Create a non-root user
#RUN groupadd -g 2000 nik \#
#&& useradd -m -u 2000 -g 2000 nik#

COPY . ./

# Adjust ownership of the working directory to the non-root user
RUN chown -R nik:nik /app

RUN dotnet restore

USER nik

RUN dotnet publish "dotnet6.csproj" -c Release -o /app/publish


FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
COPY --from=build /app/publish .
ENV ASPNETCORE_URLS http://*:5000

EXPOSE 5000
ENTRYPOINT ["dotnet", "dotnet6.dll"]

