#!/bin/sh -l
sh -c "Running github action: $APP_NAME"
sh -c pandoc --version
sh -c make pdf