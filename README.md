## PhyloZoom API

[![Travis](https://img.shields.io/travis/bcbi/phylozoom-frontend.svg?style=flat-square)](https://travis-ci.org/bcbi/phylozoom-frontend)
[![License](https://img.shields.io/badge/license-MIT-orange.svg?style=flat-square)](https://github.com/bcbi/phylozoom-api/blob/master/LICENSE)
[![Docker](https://img.shields.io/badge/docker-latest-000fff.svg?style=flat-square)](https://hub.docker.com/r/fernandogelin/phylozoom-api/)


## Overview
Julia API to parse and access subtrees of a large tree in [newick format](https://en.wikipedia.org/wiki/Newick_format).
At the moment the parser is specific to the tree in `src/hd_consensus_tree.nwk`. Eventually we plan to generalize the application.

This API serves as the backend of PhytoKB Tree View, which is a visualization tool based on [D3.js](https://d3js.org/) and [Phylotree.js](https://github.com/veg/phylotree.js/wiki/phylotree.js-API).

## Requirements
- [Julia 0.6](https://julialang.org/downloads/)
- [HTTP.jl](https://github.com/JuliaWeb/HTTP.jl)

## Usage
To run:
```bash
julia api/server.jl
```

The API will be served to `0.0.0.0:8089`. You can use [Postman](https://www.getpostman.com/) to make API calls using the keys `id` and `levels` (how many levels up you want to navigate the tree from the taxon identified with ID).  

Ex.: `0.0.0.0:8089/?id=dr_1172206&levels=1`

## Using Docker

```bash
docker pull bcbi/phylozoom-api
docker run -p 8089:8089 bcbi/phylozoom-api
```

## Or to run the web application with the frontend:
```bash
docker-compose up
```
And navigate to `localhost:8080` on your browser.
