# Use an official Node.js runtime as a parent image
FROM node:17

# Set the working directory to /app/backend
WORKDIR /app/backend

# Copy the package.json and package-lock.json to the container
COPY package*.json ../

# Install backend dependencies
RUN npm install

# Copy the rest of your backend application to the container
COPY . .

# Expose the port your Express.js app listens on (e.g., 5000)
EXPOSE 5000

# Define the command to start your Express.js server
CMD ["npm", "start"]
