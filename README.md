# README

## Installation

Clone this repo and run following commands:

```
$ bundle install
$ ./bin/yarn install
```

## Using

### Starting dev server without SSL

If you have installed foreman, you can use Procfile to configure application and simply run `foreman start`.

But in development foreman blocks `binding.pry` code from executing, and you will never 
access the `binding.pry` point from the console.

In case of that just run in two consoles/tabs following commands:

```
// 1 (backend)
$ rails s

// 2 (frontend)
$ ./bin/webpack-dev-server
```

### Starting dev server with SSL

To test/use slotmachine on some site you'll need to start both servers using ssl, since shopify 
blocks non-htttps requests. To do this, you need to find `config/webpacker.yml` file 
and set `https:` option to `true`:

```yaml
development:
  dev_server:
    https: true
```

Only after this you can run the following commands:

```
// 1 (backend)
$ rvmsudo thin start --ssl -p 443

// 2 (frontend)
$ ./bin/webpack-dev-server
```

## Deploy

A list of notes to keep in mind while pushing to heroku

- after successful deploy don't forget to run `heroku run rails db:migrate` to migrate database
