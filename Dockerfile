# Rails 6 Production Dockerfile (Debian slim, parallel build, no PID files)

# ========== Node.js Dependencies Stage ==========
FROM node:12.22.1-buster-slim AS node-deps
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn --version && \
    yarn install \
      --frozen-lockfile \
      --production=false \
      --network-concurrency 16 \
      --child-concurrency 8

# ========== Ruby Dependencies Stage ==========
FROM ruby:2.6.10-slim AS ruby-deps
RUN apt-get update -y && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    imagemagick \
    tzdata \
    git \
    curl \
    gnupg \
    shared-mime-info \
    file \
  && rm -rf /var/lib/apt/lists/*

ENV BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_BIN=/usr/local/bundle/bin \
    BUNDLE_JOBS=8 \
    BUNDLE_RETRY=1 \
    BUNDLE_WITHOUT="development:test" \
    BUNDLE_DEPLOYMENT=1 \
    MAKEFLAGS="-j$(nproc)" \
    SASSC_THREADS="$(nproc)"
ENV PATH="${BUNDLE_BIN}:${PATH}"

RUN gem update --system 3.2.3 && gem install bundler -v 2.4.22

WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs "${BUNDLE_JOBS}" --retry ${BUNDLE_RETRY} \
 && bundle clean --force \
 && rm -rf ${BUNDLE_PATH}/cache/*.gem \
 && find ${BUNDLE_PATH}/gems/ -name "*.c" -delete || true \
 && find ${BUNDLE_PATH}/gems/ -name "*.o" -delete || true

# ========== Assets Builder Stage ==========
FROM ruby:2.6.10-slim AS assets-builder
COPY --from=node-deps /usr/local /usr/local
COPY --from=node-deps /opt /opt
ENV PATH="/usr/local/bin:/opt/yarn/bin:${PATH}"

RUN node -v && npm -v && which yarn && yarn -v

RUN apt-get update -y && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    libpq-dev \
    imagemagick \
    tzdata \
    git \
    shared-mime-info \
    file \
  && rm -rf /var/lib/apt/lists/*

ENV BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_BIN=/usr/local/bundle/bin \
    BUNDLE_WITHOUT="development:test" \
    BUNDLE_DEPLOYMENT=1 \
    MAKEFLAGS="-j$(nproc)" \
    SASSC_THREADS="$(nproc)" \
    JOBS="$(nproc)" \
    npm_config_jobs="$(nproc)"
ENV PATH="${BUNDLE_BIN}:${PATH}"

RUN gem update --system 3.2.3 && gem install bundler -v 2.4.22

WORKDIR /app
COPY --from=ruby-deps /usr/local/bundle /usr/local/bundle
COPY --from=node-deps /app/node_modules ./node_modules
COPY . .

RUN bundle check

ENV RAILS_ENV=production RACK_ENV=production NODE_ENV=production \
    SECRET_KEY_BASE=dummy_secret_for_asset_compilation \
    RUBYOPT="-W0" SASS_QUIET_DEPS=true \
    SKIP_MOUNT_ROUTES=1 \
    DATABASE_URL=postgresql://postgres:postgres@localhost:5432/dummy

# ※ tmp/pids は作らない
RUN mkdir -p tmp/cache tmp/sockets log public/assets public/packs \
 && bundle exec rails assets:precompile \
 && rm -rf node_modules tmp/cache log/*

# ========== Final Production Web Image ==========
FROM ruby:2.6.10-slim AS web
RUN apt-get update -y && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    postgresql-client \
    imagemagick \
    tzdata \
    bash \
    shared-mime-info \
    curl \
    file \
  && rm -rf /var/lib/apt/lists/*

ENV TZ=Asia/Tokyo \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_BIN=/usr/local/bundle/bin \
    BUNDLE_WITHOUT="development:test" \
    BUNDLE_DEPLOYMENT=1
ENV PATH="${BUNDLE_BIN}:${PATH}"

WORKDIR /app
COPY --from=ruby-deps      /usr/local/bundle /usr/local/bundle
COPY . .
COPY --from=assets-builder /app/public/assets ./public/assets
COPY --from=assets-builder /app/public/packs  ./public/packs

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh \
 && mkdir -p tmp/cache tmp/sockets log \
 && chmod -R 755 bin/*

ARG BUILD_DATE
ARG BUILD_TAG
ENV BUILD_DATE=${BUILD_DATE} \
    BUILD_TAG=${BUILD_TAG} \
    RAILS_ENV=production \
    RACK_ENV=production \
    RUBYOPT="-W0" \
    SASS_QUIET_DEPS=true

EXPOSE 3000
ENTRYPOINT ["entrypoint.sh"]
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]