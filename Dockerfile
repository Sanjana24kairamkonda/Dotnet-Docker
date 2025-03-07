# Use the official .NET SDK image to build the app (for .NET 7.0)
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build

# Set the working directory inside the container
WORKDIR /src

# Copy the .csproj file and restore any dependencies (via NuGet)
COPY DotnetApp.csproj ./
RUN dotnet restore

# Copy the rest of the application code
COPY . ./

# Build the application
RUN dotnet publish -c Release -o /app

# Set up the runtime image to run the app (for .NET 7.0)
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80

# Copy the build artifacts from the build stage
COPY --from=build /app .

# Set the entry point to run the application
ENTRYPOINT ["dotnet", "DotnetApp.dll"]

