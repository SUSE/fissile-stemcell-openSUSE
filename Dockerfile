ARG base_image
FROM ${base_image}

ARG stemcell_version
RUN [ -n "$stemcell_version" ] || (echo "stemcell_version needs to be set"; exit 1)

LABEL stemcell-flavor=opensuse
LABEL stemcell-version=${stemcell_version}

# Install Ruby & wget
RUN zypper -n in ruby tar wget
# Install dumb-init
RUN wget -O /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 \
        && chmod +x /usr/bin/dumb-init

# Install additional dependencies
RUN zypper -n in jq rsync fuse

ADD monitrc.erb /opt/fissile/monitrc.erb

ADD post-start.sh /opt/fissile/post-start.sh
RUN chmod ug+x /opt/fissile/post-start.sh

# Add rsyslog configuration
ADD rsyslog_conf/etc /etc/
