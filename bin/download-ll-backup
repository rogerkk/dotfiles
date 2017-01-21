#!/bin/bash

curl -o ~/Projects/legelisten-backups/$(date +"%Y-%m-%d").dump `heroku pg:backups public-url --app legelisten`
