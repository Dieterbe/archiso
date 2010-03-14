#!/bin/sh

for x in $(cat purge.lst); do
    rm -rf work/$x
done
