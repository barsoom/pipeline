ARG RUBY_VERSION

FROM ruby:${RUBY_VERSION}-alpine AS build
RUN adduser -S -h /app -u 10000 app
WORKDIR /app
COPY Gemfile Gemfile.lock .ruby-version ./
ENV BUNDLE_IGNORE_FUNDING_REQUESTS=yes \
    BUNDLE_IGNORE_MESSAGES=yes \
    RAILS_ENV=production \
    SECRET_KEY_BASE=does_not_matter_here
RUN apk --no-cache add --virtual build-dependencies build-base git postgresql-dev yaml-dev \
    && gem install bundler -v "$(grep -A 1 "BUNDLED WITH" Gemfile.lock | tail -n 1)" \
    && bundle config set --local deployment 'true' \
    && bundle config set --local without 'development test' \
    && bundle install --jobs "$(nproc)"
COPY --chown=app:nogroup . .
RUN bundle exec rake assets:precompile
RUN rm -rf /app/tmp/cache \
    && find . -type d -name ".git" -exec rm -rf {} + \
    && find vendor/bundle -type d -name "spec" -exec rm -rf {} + \
    # && find vendor/bundle -type d -name "test" -exec rm -rf {} + \ # Can't do this because of rack-test, which is a dependency of actionpack https://auctionet.slack.com/archives/CF9SAN79V/p1634131104108900
    && find vendor/bundle -type d -name "src" -exec rm -rf {} + \
    && find vendor/bundle -type f -name '*.o' -delete

FROM ruby:${RUBY_VERSION}-alpine
RUN adduser -S -h /app -u 10000 app
WORKDIR /app
COPY --from=build /app /app
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /app/vendor/bundle /app/vendor/bundle
RUN apk --no-cache add --virtual runtime-dependencies \
  postgresql-client \
  tzdata \
  bash \
  libstdc++  # /app/vendor/bundle/ruby/3.4.0/gems/ffi-1.17.1-x86_64-linux-musl/lib/ffi/dynamic_library.rb:94:in 'FFI::DynamicLibrary.load_library': Could not open library '/app/vendor/bundle/ruby/3.4.0/gems/sassc-2.4.0/lib/sassc/libsass.so': Error loading shared library libstdc++.so.6: No such file or directory (needed by /app/vendor/bundle/ruby/3.4.0/gems/sassc-2.4.0/lib/sassc/libsass.so). (LoadError)
ENV RAILS_ENV=production

ARG REVISION
RUN echo ${REVISION} > built_from_revision
ENV PATH=/app/bin:${PATH}
