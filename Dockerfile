# Step 1: Use the Ruby base image
FROM ruby:3.1.3
LABEL authors="krishnadiamesso"

# Step 2: Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Step 3: Install Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn

# Step 4: Set the working directory inside the container
WORKDIR /app

# Step 5: Copy the Gemfile and Gemfile.lock
COPY Gemfile /app/Gemfile

# Step 6: Install gems
RUN bundle install

# Step 7: Copy the main application
COPY . /app

# Step 8: Precompile Rails assets (Optional step based on your app)
RUN RAILS_ENV=production bundle exec rake assets:precompile

# Step 9: Start the Rails app
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]
