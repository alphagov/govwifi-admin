FROM ruby:2.6.2
ARG BUNDLE_INSTALL_CMD

# required for certain linting tools that read files, such as erb-lint
ENV LANG 'C.UTF-8'

ENV RACK_ENV development
ENV DB_USER root
ENV DB_PASS root
ENV NOTIFY_API_KEY 'govwifi_admin_development-8a09d848-d453-4aea-bb1e-46f7d19a1814-d2306cbb-39f5-40e5-9f86-1778c2bef6fa'
ENV DB_HOST db
ENV DEVISE_SECRET_KEY fake-secret-key
ENV LONDON_RADIUS_IPS '111.111.111.111,121.121.121.121'
ENV DUBLIN_RADIUS_IPS '222.222.222.222,232.232.232.232'
ENV S3_PUBLISHED_LOCATIONS_IPS_BUCKET 'StubBucket'
ENV S3_PUBLISHED_LOCATIONS_IPS_OBJECT_KEY 'StubKey'
ENV S3_SIGNUP_WHITELIST_BUCKET 'StubBucket'
ENV S3_SIGNUP_WHITELIST_OBJECT_KEY 'StubKEY'
ENV S3_WHITELIST_OBJECT_KEY 'WhitelistStubKey'
ENV LOGGING_API_SEARCH_ENDPOINT 'https://govwifi-logging-api.gov.uk/search/'
ENV S3_MOU_BUCKET 'StubMouBucket'

ENV RR_DB_USER root
ENV RR_DB_PASS root
ENV RR_DB_HOST rr_db
ENV RR_DB_NAME rr_govwifi

WORKDIR /usr/src/app

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
  apt-get update && apt-get install -y apt-transport-https nodejs libuv1 && \
  curl -o- -L https://yarnpkg.com/install.sh | bash -s -- --version 1.9.4 && \
  rm -rf /var/lib/apt/lists/*
ENV PATH "$PATH:/root/.yarn/bin:/root/.config/yarn/global/node_modules/.bin"

COPY Gemfile Gemfile.lock .ruby-version ./
ARG BUNDLE_INSTALL_FLAGS
RUN bundle install --no-cache ${BUNDLE_INSTALL_FLAGS}

COPY package.json yarn.lock ./
RUN yarn

COPY . .

ARG RUN_PRECOMPILATION=true
RUN if [ ${RUN_PRECOMPILATION} = 'true' ]; then \
  ASSET_PRECOMPILATION_ONLY=true RAILS_ENV=production bundle exec rails assets:precompile; \
  fi
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
