# README
Quickstart for using Square's Web Payments SDK on Rails.
This project is based on following documents.

- [https://developer.squareup.com/docs/web-payments/take-card-payment](https://developer.squareup.com/docs/web-payments/take-card-payment)

- [https://github.com/square/web-payments-quickstart/blob/main/public/examples/card.html](https://github.com/square/web-payments-quickstart)

Things you may want to cover:

* Ruby version: 2.7.1

## Deployment instructions

1. create file .env at root of project folder.
2. In that .env, add following lines,and replace "?" with your sandbox environment values appropriately.

```
APPLICATION_ID="sandbox-?"
LOCATION_ID="?"
SQUARE_ACCESS_TOKEN="?"
```
	
3. rails webpacker:install (if you need.)
4. rails webpacker:compile (if you need.)
5. bundle install
6. start server(ex. rails s)