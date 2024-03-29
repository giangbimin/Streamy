# https://www.ruby-lang.org/vi/news/2016/12/25/ruby-2-4-0-released/
# Be sure to restart your server when you modify this file.

# You can add backtrace silencers for libraries that you're using but don't wish to see in your backtraces.
# Rails.backtrace_cleaner.add_silencer { |line| /my_noisy_library/.match?(line) }

# You can also remove all the silencers if you're trying to debug a problem that might stem from framework code
# by setting BACKTRACE=1 before calling your invocation, like "BACKTRACE=1 ./bin/rails runner 'MyClass.perform'".
Rails.backtrace_cleaner.remove_silencers!

# Add backtrace silencer
# Default silencer is removing backtrace involving engines files
# Our silencer also checks for engines directory
# Ref: https://github.com/rails/rails/blob/master/railties/lib/rails/backtrace_cleaner.rb
Rails.backtrace_cleaner.add_silencer do |line|
  !(Rails::BacktraceCleaner::APP_DIRS_PATTERN.match?(line) || /^engines/.match?(line))
end