FROM ruby

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# S3 backup script

COPY Gemfile /usr/src/app/Gemfile
COPY Gemfile.lock /usr/src/app/Gemfile.lock
RUN bundle config build.nokogiri --use-system-libraries
RUN bundle install
COPY s3backup.rb /usr/local/bin/

# Postgres client
RUN set -x \
	&& apt-get update && apt-get install -y postgresql-client-9.5 && rm -rf /var/lib/apt/lists/*

COPY pgbackup.sh /usr/local/bin/

# Set timezone
RUN echo "UTC" > /etc/timezone \
    && dpkg-reconfigure --frontend noninteractive tzdata

# go-cron
RUN curl -SL https://github.com/odise/go-cron/releases/download/v0.0.7/go-cron-linux.gz \
	| zcat > /usr/local/bin/go-cron && chmod u+x /usr/local/bin/go-cron
COPY go-cron.sh /usr/local/bin

RUN chmod +x /usr/local/bin/s3backup.rb /usr/local/bin/pgbackup.sh /usr/local/bin/go-cron.sh

EXPOSE 18080
CMD ["go-cron.sh"]

