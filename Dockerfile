
# Use Amazon Linux as the base image to avoid Docker Hub's throttling
FROM public.ecr.aws/amazonlinux/amazonlinux:latest

# Install Node.js (updated to a more recent LTS version)
RUN curl -sL https://rpm.nodesource.com/setup_16.x | bash - \
    && yum install -y nodejs \
    && yum -y clean all \
    && rm -rf /var/cache/yum

# Set the working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy the application code
COPY . .

# Build the application
RUN npm run build

# Expose port 80
EXPOSE 80

# Add additional resources (ensure this directory exists in your project)
RUN mkdir -p ./public/images
ADD https://raw.githubusercontent.com/aws-containers/hello-app-runner/2356069859f2ac2e4c0300b510911a7a48d75337/banner_base_light.png ./public/images/

# Start the application
CMD [ "npm", "start" ]

