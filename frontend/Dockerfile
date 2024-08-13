FROM node:alpine as build
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build:prod

# production environment
FROM nginx:stable-alpine
COPY --from=build /app/build /usr/share/nginx/html
COPY --from=build /app/nginx/default.conf /etc/nginx/conf.d/default.conf
COPY ./robots.txt /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
