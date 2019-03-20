This creates a Docker image capable of running rspec tests for
OpenStack puppet modules.  I use it like this when working with
[puppet-keystone][]:

[puppet-keystone]: https://github.com/openstack/puppet-keystone

    docker run --rm -it \
      -e SPEC_OPTS='--fail-fast --format documentation' \
      -v /tmp/rspec:/var/cache/rspec \
      -v $PWD:/module \
      -w /module \
      larsks/rspec \
      run-rspec

The `run-spec` script will copy the contents of the current directory
(`/module` because of `-w /module` in the above command) into a
temporary location, and then proceed to run:

    bundle install
    bundle exec rake spec_prep
    bundle exec rake spec_standalone

It runs the tests in a temporary location because otherwise it will
drop root-owned content into your current directory and artifacts into
your `.git` directory.

The `-v /tmp/rspec:/var/cache/rspec` preserves the gems and other
artifacts that are installed to support the tests, which means that
subsequently I can run:

    docker run --rm -it \
      -e SPEC_OPTS='--fail-fast --format documentation' \
      -v /tmp/rspec:/var/cache/rspec \
      -v $PWD:/module \
      -w /module \
      larsks/rspec \
      run-rspec --standalone

The `--standalone` flag skips the `bundle install` and `bundle exec
rake spec_prep` steps, which means the tests will start running
immediately.
