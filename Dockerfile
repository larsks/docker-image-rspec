FROM centos:7

ARG OPENSTACK_RELEASE=rocky

RUN yum -y install centos-release-openstack-${OPENSTACK_RELEASE} && \
	yum -y install \
		rsync \
		puppet \
		git \
		rubygem-bundler \
		gcc \
		gcc-c++ \
		make \
		ruby-devel \
		libxml2-devel \
		zlib-devel && \
	yum clean all

VOLUME /var/cache/rspec

ENV GEM_HOME=/var/cache/rspec/bundle
COPY run-rspec.sh /bin/run-rspec
COPY r10k.yaml /etc/puppetlabs/r10k/r10k.yaml
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["sh", "/entrypoint.sh"]
