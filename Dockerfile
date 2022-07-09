FROM ruby:2.7.0

RUN apt-get update && apt-get install -y \
  curl \
  build-essential \
  wget \
  libpq-dev && \
  wget https://dl.yarnpkg.com/debian/pubkey.gpg && \
  curl https://deb.nodesource.com/setup_12.x | bash && \
  cat pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && apt-get install -y nodejs yarn

RUN rm pubkey.gpg

RUN mkdir /workspace
WORKDIR /workspace

EXPOSE 3000

COPY Gemfile ./
COPY Gemfile.lock ./

RUN apt-get install -y shared-mime-info
RUN gem install mimemagic -v '0.3.10' --source 'https://rubygems.org/'
RUN gem install rails bundler
RUN bundle install

COPY . ./
RUN chmod +x /workspace/bin/rails
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | /bin/bash -


RUN chmod 0755 /workspace/bin/rails
RUN chmod 0755 /workspace/bin/start.sh
# Start the application server
ENTRYPOINT [ "/bin/bash","./bin/start.sh" ]
