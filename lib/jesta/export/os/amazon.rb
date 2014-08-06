require 'rubygems'
require 'aws-sdk'

require 'jesta/export/export'

module Jesta
  module Export
    module OS

      class Amazon < Export
    
        def initialize
          super()
        end

        def get_origin_image_with_debug(export_instance, export_ebs,
                                        host_name, user_name, key_path, kernel_version)
          begin
            Net::SSH.start(host_name, user_name,
                           :keys => key_path) do |ssh|
              puts "install kernel"
              puts ssh.exec!("sudo yum -y install kernel-" + kernel_version)

              puts "install debuginfo"
              puts ssh.exec!("sudo sudo debuginfo-install -y kernel-" + kernel_version)

              puts "install debug tools"
              puts ssh.exec!("sudo sudo yum install -y systemtap")
              puts ssh.exec!("sudo yum install -y perf strace")

              puts "get debug kernel"
              puts ssh.exec!("echo \"yes\" | get_reference_source --package=kernel-" + kernel_version)
            end
          rescue SystemCallError, Timeout::Error => e
            $logger.warn("unable to ssh" +  host_name)
          end

          get_origin_image(export_instance, export_ebs, host_name, 
                           user_name, key_path)
        end  

      end
    end
  end
end
