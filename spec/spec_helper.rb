require 'bundler/setup'
Bundler.setup

require 'csv_report'

RSpec.configure do |config|
  config.order = "random"
end
