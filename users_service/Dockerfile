# Use the official Ruby 2.7 image as a parent image
FROM ruby:2.7.6

# Install system dependencies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Set the working directory in the container
WORKDIR /app

# Copy the Gemfile and Gemfile.lock into the container
COPY Gemfile Gemfile.lock ./

# Install gem dependencies
RUN bundle install

# Copy the rest of the application into the container
COPY . .

# Start the main process
CMD ["rails", "server", "-b", "0.0.0.0"]
