FROM splatform/os-image-opensuse:42.3

# Install RVM & Ruby 2.3.1
RUN zypper -n in --force-resolution libopenssl-devel \
        && gpg2 --keyserver pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB \
        && curl -sSL https://get.rvm.io | bash -s stable --ruby=2.3.1 \
        && /bin/bash -c "source /usr/local/rvm/scripts/rvm && gem install bundler '--version=1.11.2' --no-format-executable" \
        && echo "source /usr/local/rvm/scripts/rvm" >> ~/.bashrc

# Install dumb-init
RUN wget -O /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 \
        && chmod +x /usr/bin/dumb-init

# Install configgin
RUN /bin/bash -c "source /usr/local/rvm/scripts/rvm && gem install configgin --pre"

# Install additional dependencies
RUN zypper -n in gettext-tools
