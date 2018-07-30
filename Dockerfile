FROM ruby:2.5-alpine
ARG BUNDLE_INSTALL_CMD
ENV RACK_ENV=development

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock .ruby-version ./
RUN apk --update --upgrade add build-base sqlite-dev tzdata && \
  bundle check || ${BUNDLE_INSTALL_CMD} && \
  apk del build-base && \
  find / -type f -iname \*.apk-new -delete && \
  rm -rf /var/cache/apk/*

COPY . .

CMD ["bundle", "exec", "rails", "server"]
