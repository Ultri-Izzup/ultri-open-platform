# Nuggets

## Nugget Data Server

The Nugget Data Server powers [Izzup.com](https://www.izzup.com). It utilizes Postgres and Redis to provide performant, scalable data solutions. 

Fully dockerized it can be run in any environment. The same components used in production are used for local dockerized development. This makes development and promotion of code easier, quicker and safer.

Data is consumed and updated over a conventional HTTP API, client libraries will assist in navigating and accessing Nuggets. The frontend client is designed to support offline usage and the production izzup.com code is provided as a reference.

