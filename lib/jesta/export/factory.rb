require 'jesta/export/os/amazon'

module Jesta
  module Export
    class Factory

      def create_factory(type)
        if type == "amazon"
          exp = Jesta::Export::OS::Amazon.new
        elsif type == "rhel" 
        elsif type == "ubuntu"
        end

        exp
      end

    end
  end
end

