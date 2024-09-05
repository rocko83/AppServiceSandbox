FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
WORKDIR /src/AppServiceContainer
COPY . .
RUN dotnet restore "AppServiceContainer/AppServiceContainer.csproj"
COPY . .
WORKDIR "/src/AppServiceContainer"
RUN dotnet build "AppServiceContainer/AppServiceContainer.csproj" -c $BUILD_CONFIGURATION -o /app/build
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "AppServiceContainer/AppServiceContainer.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
USER $APP_UID
WORKDIR /app
EXPOSE 8080
EXPOSE 8081
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "AppServiceContainer.dll"]
