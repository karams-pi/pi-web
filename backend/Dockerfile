# Build Stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copiar apenas os arquivos de projeto primeiro para aproveitar o cache de camadas
COPY ["Pi.Api/Pi.Api.csproj", "Pi.Api/"]
RUN dotnet restore "Pi.Api/Pi.Api.csproj"

# Copiar todo o resto e buildar
COPY . .
WORKDIR "/src/Pi.Api"
RUN dotnet build "Pi.Api.csproj" -c Release -o /app/build

# Publish Stage
FROM build AS publish
RUN dotnet publish "Pi.Api.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Final Stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Pi.Api.dll"]
