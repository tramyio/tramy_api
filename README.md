# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

- Ruby version

- System dependencies

- Configuration

- Database creation

- Database initialization

- How to run the test suite

- Services (job queues, cache servers, search engines, etc.)

- Deployment instructions

- ...

# Tramy's guidelines:

## ActionController

- Add a brief description if the method becomes complex

## ActiveRecord

- Follow the order: associations, validations, scopes, callbacks.
- For printing queries in rails console, after throwing a search, type: ap \_ to see a friendly result (development-only)

## How to install Tramy's local enviroment:

### Install

- Clone this repository
- Install Ruby 2.7.2 and Rails 6.0.4
- Then run the following command `bundle install`

### Port

- Expose one of your ports (usually port 3000) for API (We suggest you to use Ngrok or Localtunnel)
- Option 1: Paste your your_exposed_port_url in `development.rb` at the end of the file and paste config.hosts << "your_exposed_port_url"
- Option 2 (Recent): Tramy is configured to accept request from all sources just in development mode. Check more about _config.hosts.clear_

### Providers

- Create an account in Hookdeck (Ask for your team access to your manager)
- Enter Hookdeck, setup a connection source (360dialog) and destination (your Ngrok/Localtunnel url)
- Setup webhook url in https://waba-sandbox.360dialog.io/v1/configs/webhook and pass as body payload { "url": "your_hookdeck_event_url?number=xxxxxxxxxxxx" }

### Heroku

- Ask your manager for access
- In order to avoid rewriting the app name every time you hit a command, just run this: heroku git:remote -a tramyback

### You're ready to code
