FROM node:latest
ENV NODE_ENV=production
ENV REACT_APP_API_URL=http://localhost:5000/api/topics
WORKDIR /frontend
COPY ["package.json", "package-lock.json","./"]
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
