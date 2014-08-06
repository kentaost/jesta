require 'rubygems'
require 'aws-sdk'

require 'jesta/export/factory'

module Jesta
  module CMD
    class Export
      @exp
  
      def export_from_instance(export_instance, export_ebs, os_type, host_name, user_name, key_path)
        $logger.info "export from origin instance..."
        @exp = Jesta::Export::Factory.new.create_factory(os_type)
        @exp.get_origin_image(export_instance, export_ebs, host_name, user_name, key_path)
      end

      def export_from_instance_with_debugkernel(export_instance, export_ebs, os_type, 
                                                host_name, user_name, key_path, kernel_version)
        $logger.info "export from origin instance with debug tools..."
        @exp = Jesta::Export::Factory.new.create_factory(os_type)
        @exp.get_origin_image_with_debug(export_instance, export_ebs, host_name,
                                         user_name, key_path, kernel_version)
      end

    end
  end
end
