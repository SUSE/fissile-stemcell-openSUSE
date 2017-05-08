FROM splatform/os-image-opensuse:42.2
RUN zypper -n in --force-resolution libopenssl-devel \
        && gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 \
        && curl -sSL https://get.rvm.io | bash -s stable --ruby=2.3.1 \
        && /bin/bash -c "source /usr/local/rvm/scripts/rvm && gem install bundler '--version=1.11.2' --no-format-executable" \
        && echo "source /usr/local/rvm/scripts/rvm" >> ~/.bashrc
RUN wget -O /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 \
        && chmod +x /usr/bin/dumb-init
COPY assets/configgin-*.gem /tmp
RUN /bin/bash -c "source /usr/local/rvm/scripts/rvm && gem install /tmp/configgin-*.gem && rm /tmp/configgin-*.gem"
