# Use the official .NET image as a base
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

# Use SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["DotnetApp/DotnetApp.csproj", "DotnetApp/"]
RUN dotnet restore "DotnetApp/DotnetApp.csproj"
COPY . .
WORKDIR "/src/DotnetApp"
RUN dotnet build "DotnetApp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "DotnetApp.csproj" -c Release -o /app/publish

# Final image setup
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DotnetApp.dll"]

