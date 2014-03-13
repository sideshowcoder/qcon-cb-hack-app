# QCon Couchbase Hack Challenge

App to host the backend for the QCon Couchbase Hack Challenge

## Setup and Run

Start sync_gateway and a webserver

    $ bundle exec foreman start

open [localhost:4000](http://localhost:4000)

## Development
Start a development server

    $ rake server

open [localhost:3000](http://localhost:3000) the server will run via shotgun so
it reloads on code change

Start a irb session

    $ rake console

## Test
k
    $ rake test

## Setup

Couchbase Hack Challenge runs currently on AWS on Ubuntu 12.04LTS

* Install Couchbase Server
* Install Couchbase Sync Gateway
* Install Nginx
* Install libcouchbase
* Install ruby 2.1
* Clone the repo

* Install the ruby dependencies

    $ bundle install

* Setup the configuration (nginx, sync\_gateway, views)

    $ rake deploy

* Fill in configuration in .env, copy sample.env for reference
* Start and run via god

    $ bundle exec god -c config/qcon_cb_hack_app.god

## Solve the challenge
An example see [QCon iOS example](https://github.com/sideshowcoder/QConCBHack)

## License
MIT

