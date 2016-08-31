# 
# Fluentd Docker Image for Open DevOps Pipeline 
# 
# VERSION : 1.0 
# 
FROM       alpine
MAINTAINER Open DevOps Team <open.devops@gmail.com>

ENV REFRESHED_AT 2016-08-25

ENV FLUENTD_VERSION 0.14.3
ENV RUBY_VERSION 2.3.0

RUN apk --no-cache --update add \
                            build-base \
                            ca-certificates \
                            ruby \
                            ruby-irb \
                            ruby-dev && \
    echo 'gem: --no-document' >> /etc/gemrc && \
    gem install oj && \
    gem install fluentd -v ${FLUENTD_VERSION} && \
    apk del build-base ruby-dev && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /usr/lib/ruby/gems/*/cache/*.gem

RUN adduser -D -g '' -u 1000 -h /home/fluent fluent
RUN chown -R fluent:fluent /home/fluent

# for log storage (maybe shared with host)
RUN mkdir -p /fluentd/log
# configuration/plugins path (default: copied from .)
RUN mkdir -p /fluentd/etc /fluentd/plugins

RUN chown -R fluent:fluent /fluentd

USER fluent
WORKDIR /home/fluent

# Tell ruby to install packages as user
RUN echo "gem: --user-install --no-document" >> ~/.gemrc
ENV PATH /home/fluent/.gem/ruby/${RUBY_VERSION}/bin:$PATH
ENV GEM_PATH /home/fluent/.gem/ruby/${RUBY_VERSION}:$GEM_PATH

# Install plugins
RUN gem install fluent-plugin-elasticsearch fluent-plugin-record-reformer

COPY fluent.conf /fluentd/etc/

ENV FLUENTD_OPT=""
ENV FLUENTD_CONF="fluent.conf"

EXPOSE 24224 5140

CMD exec fluentd -c /fluentd/etc/$FLUENTD_CONF -p /fluentd/plugins $FLUENTD_OPT
