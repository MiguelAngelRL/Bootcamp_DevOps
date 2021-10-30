# Intermediate image for building and publishing the project

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /app
# Copy csproj and restore
COPY "backend.csproj" ./
RUN dotnet restore
# Copy everything else, build and publish
COPY . ./
RUN dotnet build "backend.csproj" -c Release -o ./build/
RUN dotnet publish -c Release -o ./publish/



# Final image for running the application

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
ENV MONGO_URI="mongodb://myadmin:mypass@myrepository"
WORKDIR /app
EXPOSE 80
# Copy builded application
COPY --from=build /app/publish/ .
# Start application in container
ENTRYPOINT ["dotnet", "backend.dll"]
