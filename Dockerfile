ARG base_image=splatform/os-image-opensuse:42.3-29.89.0

FROM ${base_image}

# Install RVM & Ruby 2.3.1
RUN zypper -n in --force-resolution libopenssl-devel \
        && gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 \
        && curl -sSL https://raw.githubusercontent.com/rvm/rvm/stable/binscripts/rvm-installer | bash -s stable --ruby=2.3.1 \
        && /bin/bash -c "source /usr/local/rvm/scripts/rvm && gem install bundler '--version=1.11.2' --no-format-executable" \
        && echo "source /usr/local/rvm/scripts/rvm" >> ~/.bashrc
# Install dumb-init
RUN wget -O /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 \
        && chmod +x /usr/bin/dumb-init

# Install configgin
# Putting this ARG to the top of the file mysteriously makes it always empty :|
ARG configgin_version
RUN /bin/bash -c "source /usr/local/rvm/scripts/rvm && gem install configgin ${configgin_version:+--version=${configgin_version}}"

# Install additional dependencies
RUN zypper -n in jq rsync

ADD monitrc.erb /opt/fissile/monitrc.erb

ADD post-start.sh /opt/fissile/post-start.sh
RUN chmod ug+x /opt/fissile/post-start.sh

# Add rsyslog configuration
ADD rsyslog_conf/etc /etc/
