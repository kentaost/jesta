require 'jesta/cmd/options'

require 'jesta/cmd/export'

module Jesta
  # CLI module
  module CMD

    # execute
    # @return[void]
    def self.run
      options = Options.parse!(ARGV)
      sub_cmd = options.delete(:command)

      case sub_cmd
        when 'export-instance'
          CMD::Export.new.export_from_instance(options[:export_instance],
                                               options[:export_ebs],
                                               options[:os_type],
                                               options[:host_name],
                                               options[:user_name],
                                               options[:key_path])
        when 'export-debug-instance'
          CMD::Export.new.export_from_instance_with_debugkernel(options[:export_instance],
                                                                options[:export_ebs],
                                                                options[:os_type],
                                                                options[:host_name],
                                                                options[:user_name],
                                                                options[:key_path],
                                                                options[:kernel_version])
        when 'export-debug-kernel'
          CMD::Export.new.export_from_instance_with_specified_kernel(options[:kernel_version],
                                                                     options[:os_type],
                                                                     options[:host_name],
                                                                     options[:user_name],
                                                                     options[:key_path])
        when 'convert-pv-to-hvm'
          CMD::Export.new.convert_pv_to_hvm(options[:pv_instance],
                                            options[:os_type],
                                            options[:host_name],
                                            options[:user_name],
                                            options[:key_path])
      end
    end
  end
end
