FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["src/PhoneShop.Basket.WebApi/PhoneShop.Basket.WebApi.csproj", "PhoneShop.Basket.WebApi/"]

COPY . .
WORKDIR /src
RUN dotnet build "src/PhoneShop.Basket.WebApi/PhoneShop.Basket.WebApi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "src/PhoneShop.Basket.WebApi/PhoneShop.Basket.WebApi.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "PhoneShop.Basket.WebApi.dll"]