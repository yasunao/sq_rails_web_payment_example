# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version: 2.7.1

## Deployment instructions

1. create file .env at root of project folder.
2. In that .env, add following lines,and replace "?" with your environment values appropriately.

```
APPLICATION_ID="sandbox-?"
LOCATION_ID="?"
SQUARE_ACCESS_TOKEN="?"
```
	
3. rails webpacker:install (if you )
4. rails webpacker:compile
5. bundle install
6. start server(ex. rails s)