#!/bin/sh

options=$(getopt -o s --long standalone -- "$@")
if [ $? -ne 0 ]; then
    echo "$0: usage: $0 [--standalone]" >&2
    exit 2
fi

eval set -- "$options"
while true; do
    case "$1" in
        -s|--standalone)
            opt_standalone=1
            shift
            ;;

        --) shift
            break
            ;;
    esac
done

echo "$0: copying $PWD to /tmp/module"
rsync -a --delete . /tmp/module
cd /tmp/module

rm -rf spec/fixtures
mkdir -p /var/cache/rspec/fixtures
ln -s /var/cache/rspec/fixtures spec/fixtures

if ! [ x"$opt_standalone" = x1 ]; then
    bundle install
    bundle exec rake spec_prep
else
	echo "$0: skipping install and spec_prep due to --standalone"
fi

bundle exec rake spec_standalone
