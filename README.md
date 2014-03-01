# QCon Couchbase Hack Challenge

App to host the backend for the QCon Couchbase Hack Challenge

## Setup and Run

    $ bundle install
    $ rake server

open [localhost:3000](http://localhost:3000)

## Test

    $ rake test

## Setup

Couchbase Hack Challenge runs currently on AWS on Ubuntu 12.04LTS

* Install Couchbase Server
* Install Couchbase Sync Gateway
* Install Nginx
* Install libcouchbase
* Install ruby 2.1
* Clone the repo
* Setup the configuration

    $ rake configure:sync_gateway
    $ rake configure:nginx

* Install the ruby dependencies

    $ bundle install

* Fill in configuration in .env, copy sample.env for reference
* Start and run via god

    $ bundle exec god -c config/qcon_cb_hack_app.god

## License
MIT

