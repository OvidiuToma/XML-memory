#!/usr/bin/env bash

SECONDS=0
ruby ruby_memory_fixed.rb $1 $2
duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."