#!/bin/sh -l
sh -c "echo Running github action: $APP_NAME"
sh -c "echo pandoc --version"
sh -c "make pdf"