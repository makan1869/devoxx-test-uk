#!/bin/bash
set -e

# Check for Maven installation
if ! command -v mvn &> /dev/null; then
    echo "Maven is required but not installed. Please install Maven first."
    exit 1i

# Build the Spring Boot application
echo "Building Spring Boot application..."
mvn clean package -DskipTests

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is required but not installed. Please install Docker first."
    exit 1
fi

# Define image name with timestamp tag for versioning
IMAGE_NAME="devoxx-test-uk"
TIMESTAMP=$(date +%Y%m%d%H%M%S)
TAG="${IMAGE_NAME}:${TIMESTAMP}"
LATEST_TAG="${IMAGE_NAME}:latest"

# Build the Docker image
echo "Building Docker image: ${TAG}"
docker build -t "${TAG}" -t "${LATEST_TAG}" .

echo "\nDocker image built successfully!"
echo "You can run the container locally with: docker run -p 8080:8080 ${LATEST_TAG}"
echo "Or use docker-compose: docker-compose up"

echo "\nTo push to ECR, you would run:"
echo "aws ecr get-login-password | docker login --username AWS --password-stdin YOUR_AWS_ACCOUNT_ID.dkr.ecr.YOUR_REGION.amazonaws.com"
echo "docker tag ${LATEST_TAG} YOUR_AWS_ACCOUNT_ID.dkr.ecr.YOUR_REGION.amazonaws.com/${IMAGE_NAME}:${TIMESTAMP}"
echo "docker tag ${LATEST_TAG} YOUR_AWS_ACCOUNT_ID.dkr.ecr.YOUR_REGION.amazonaws.com/${IMAGE_NAME}:latest"
echo "docker push YOUR_AWS_ACCOUNT_ID.dkr.ecr.YOUR_REGION.amazonaws.com/${IMAGE_NAME}:${TIMESTAMP}"
echo "docker push YOUR_AWS_ACCOUNT_ID.dkr.ecr.YOUR_REGION.amazonaws.com/${IMAGE_NAME}:latest"
