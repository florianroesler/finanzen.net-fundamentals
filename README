# Prerequisites

### When running on docker

- Docker
- docker-compose

### When not using docker

- ruby >= v2.7
- Bundler >= v2

# Installation

## When using Docker

To build the container use `docker-compose build`.

To run the container use `docker-compose run finanzen sh`

You are now able to run the commands explained below.

## When not using Docker

This assumes that you have a machine with ruby and Bundler correctly set up.

Run `bundle install` and after installation of all the required gems you should be ready to execute the commands explained below.

# Commands

Available regionss: `us, eu, de, eu`

## Collect Stock URLS for Indices

`ruby collect_urls.rb --regions us,de`

## Download HTMLs for each stock from a regions

`ruby download.rb --regions us,de`

## Transform HTML to CSV for a regions

`ruby transform.rb --regions us,de`

# Download speed

This toolchain is not intended for speed. It does not utilize multithreading and employs a rather large pause (3 seconds) between subsequent requests.

In the end, the data is collected from a webservice (finanzen.net) that should not be queried in any harmful way.
