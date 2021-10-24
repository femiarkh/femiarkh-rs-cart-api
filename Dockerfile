# ---- Base Node image ----
FROM node:12-alpine3.13 AS base
WORKDIR /app

# ---- Dependencies ----
FROM base AS dependencies
COPY package*.json ./
RUN npm install

# ---- Copy Files/Build ----
FROM dependencies AS build
WORKDIR /app
COPY . ./
RUN npm run build && npm prune --production

# ---- Release with Alphine ----
FROM node:12-alpine3.13
ENV PORT=4040
ENV NODE_ENV=production
WORKDIR /app
COPY --from=build /app/dist /app/dist
COPY --from=build /app/node_modules /app/node_modules
EXPOSE 4040
ENTRYPOINT [ "node" ]
CMD [ "dist/main.js" ]
