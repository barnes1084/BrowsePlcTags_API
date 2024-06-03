#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

# Use the official PostgreSQL image from the Docker Hub
FROM postgres:latest

# Set environment variables (optional)
ENV POSTGRES_DB=plc_tags_db
ENV POSTGRES_USER=user
ENV POSTGRES_PASSWORD=password

# Copy initialization scripts
COPY ./init.sql /docker-entrypoint-initdb.d/


#FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
#WORKDIR /app
#EXPOSE 80
#EXPOSE 443
#
#FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
#ARG BUILD_CONFIGURATION=Release
#WORKDIR /src
#COPY ["PlcTagList_API/PlcTagList_API.csproj", "PlcTagList_API/"]
#RUN dotnet restore "./PlcTagList_API/PlcTagList_API.csproj"
#COPY . .
#WORKDIR "/src/PlcTagList_API"
#RUN dotnet build "./PlcTagList_API.csproj" -c $BUILD_CONFIGURATION -o /app/build
#
#FROM build AS publish
#ARG BUILD_CONFIGURATION=Release
#RUN dotnet publish "./PlcTagList_API.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false
#
#FROM base AS final
#WORKDIR /app
#COPY --from=publish /app/publish .
#ENTRYPOINT ["dotnet", "PlcTagList_API.dll"]