FROM ruby:2.6.2-alpine3.9

# required for certain linting tools that read files, such as erb-lint
ENV LANG 'C.UTF-8'

WORKDIR /usr/src/app

RUN apk add --no-cache nodejs yarn build-base mysql-dev

COPY Gemfile Gemfile.lock .ruby-version ./

ARG BUNDLE_INSTALL_FLAGS
RUN echo "${BUNDLE_INSTALL_FLAGS}"
RUN bundle install --no-cache ${BUNDLE_INSTALL_FLAGS}

COPY package.json yarn.lock ./
RUN yarn && yarn cache clean

RUN apk del build-base

COPY . .

ARG RUN_PRECOMPILATION=true
RUN if [ ${RUN_PRECOMPILATION} = 'true' ]; then \
  ASSET_PRECOMPILATION_ONLY=true RAILS_ENV=production bundle exec rails assets:precompile; \
  fi
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
