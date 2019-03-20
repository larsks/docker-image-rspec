#!/bin/sh

mkdir -p /var/cache/rspec/r10k /var/cache/rspec/bundle
mkdir -p /root/vendor/
ln -s $GEM_HOME /root/vendor/bundle
exec "$@"
