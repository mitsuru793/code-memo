DIR_NAME = File.dirname(__FILE__)
Dir[File.join(DIR_NAME, "../lib/**/*.rb")].each { |f| require f }
