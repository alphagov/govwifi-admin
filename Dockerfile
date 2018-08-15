FROM ruby:2.5
ARG BUNDLE_INSTALL_CMD

ENV RACK_ENV development
ENV DB_USER root
ENV DB_PASS root
ENV NOTIFY_API_KEY 'govwifi_admin_development-8a09d848-d453-4aea-bb1e-46f7d19a1814-d2306cbb-39f5-40e5-9f86-1778c2bef6fa'
ENV DB_HOST db
ENV DEVISE_SECRET_KEY fake-secret-key
ENV AUTHORISED_EMAIL_DOMAINS_REGEX '.*'

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock .ruby-version ./
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  apt-get update && apt-get install -y apt-transport-https && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && apt-get install -y yarn && \
  bundle check || ${BUNDLE_INSTALL_CMD} && \
  rm -rf /var/lib/apt/lists/*

COPY . .

RUN RAILS_ENV=production rails assets:precompile

CMD ["bundle", "exec", "rails", "server"]
