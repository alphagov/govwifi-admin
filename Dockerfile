FROM ruby:2.5-alpine
ARG BUNDLE_INSTALL_CMD
ENV RACK_ENV=development
ENV DEVISE_SECRET_KEY=fake-secret-key

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock .ruby-version ./
RUN apk --update --upgrade add build-base sqlite-dev tzdata nodejs && \
  bundle check || ${BUNDLE_INSTALL_CMD} && \
  npm install -g yarn && \
  apk del build-base && \
  find / -type f -iname \*.apk-new -delete && \
  rm -rf /var/cache/apk/*

COPY . .

RUN RAILS_ENV=production rails assets:precompile

CMD ["bundle", "exec", "rails", "server"]
