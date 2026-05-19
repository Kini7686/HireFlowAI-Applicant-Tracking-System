FROM ruby:3.2.4-slim-bookworm

RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev git curl libvips && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile ./
RUN bundle install

COPY package.json* ./
RUN npm install 2>/dev/null || true

COPY . .

RUN bundle exec rails assets:precompile 2>/dev/null || true

EXPOSE 3000

CMD ["bash", "-c", "rm -f tmp/pids/server.pid && bundle exec rails db:prepare && bundle exec rails server -b 0.0.0.0"]
