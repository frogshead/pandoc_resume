#!/bin/sh -l
sh -c "echo Running github action"
sh -c "pandoc --version"
sh -c "ls -a"
sh -c "make pdf"