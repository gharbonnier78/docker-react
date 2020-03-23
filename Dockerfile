# Specify a base image
FROM ubuntu as builder


#COPY sources.list /etc/apt/sources.list
RUN apt-get clean all
RUN apt-get update

#RUN apt-get install git-core curl build-essential openssl libssl-dev python

RUN apt -y install nodejs
RUN apt -y install npm
RUN apt -y install wget curl

RUN npm cache clean -f
RUN npm install -g n
RUN n stable

WORKDIR /usr/app


# Install some depenendencies
COPY ./package.json ./
RUN npm install
COPY ./ ./

RUN npm run build

FROM nginx
EXPOSE 80
COPY --from=builder /usr/app/build /usr/share/nginx/html