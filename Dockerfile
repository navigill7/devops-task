    FROM node:18-alpine AS builder

    
    WORKDIR /usr/src/app
    
    COPY package*.json ./
    
    RUN npm install --production=false
    
    COPY . .
    FROM node:18-alpine

    WORKDIR /usr/src/app


    COPY --from=builder /usr/src/app/node_modules ./node_modules


    COPY --from=builder /usr/src/app/app.js ./app.js
    COPY --from=builder /usr/src/app/package*.json ./
    COPY --from=builder /usr/src/app/logoswayatt.png ./  

    EXPOSE 3000

    CMD ["npm", "start"]

    