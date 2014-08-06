require "yaml"

module Jesta

  # config reader
  module Settings
    extend self

    def load_config(config_path)
      begin
         @settings = YAML::load File.open(config_path)
      rescue Errno::ENOENT
        raise "#{config_path} is not found"
      rescue ArgumentError, Psych::SyntaxError => e
        raise "#{config_path} is not correct file"
      end
    end
  end
end
