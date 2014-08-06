require 'net/ssh'
require 'net/scp'

module Jesta
  module Export
    class Export
  
      def initialize
        AWS.config({
          :access_key_id => $settings["aws_config"]["access_key"],
          :secret_access_key => $settings["aws_config"]["secret_key"],
          :region => $settings["aws_config"]["region"]
        })

        @ec2 = AWS::EC2.new
      end
  
      def strip_cloudinit_setting()
        # rm -f 
      end
  
      def strip_ntp_setting()
        # rm -f
      end

      def get_origin_image(export_instance, export_ebs, host_name, user_name, key_path)
        # get volume size
        tmp_volume_size = @ec2.volumes[export_ebs].size + $settings["jesta_settings"]["additional_disk_size"]
        
        # create volume for copy
        tmp_volume = @ec2.volumes.create(:size => tmp_volume_size,
                                         :availability_zone => @ec2.instances[export_instance].availability_zone)
  
        sleep 3 until tmp_volume.status == :available
  
        # attach tmp volume to instance
        attachment = tmp_volume.attach_to(@ec2.instances[export_instance], $settings["jesta_settings"]["tmp_device_file"])
  
        # wait until "in_use"
        sleep 3 until attachment.status != :attaching
  
        # execute "dd if=/dev/(orig EBS) of=orig.img bs=4096"
        # must need sudo
        # TODO: cleanup EBS
        begin
          Net::SSH.start(host_name, user_name,
                         :keys => key_path) do |ssh|
            puts "execute \"sudo mkfs.ext4 " + $settings["jesta_settings"]["tmp_device_file"] + "\""
            puts ssh.exec!("sudo mkfs.ext4 " + $settings["jesta_settings"]["tmp_device_file"])
  
            puts "execute \"sudo mount -t ext4 " + $settings["jesta_settings"]["tmp_device_file"] + " " + $settings["jesta_settings"]["tmp_dir"] + "\""
            puts ssh.exec!("sudo mount -t ext4 " + $settings["jesta_settings"]["tmp_device_file"] + " " + $settings["jesta_settings"]["tmp_dir"])
  
            puts "execute sudo fsfreeze -f /"
            puts ssh.exec!("sudo fsfreeze -f /")
  
            puts "execute \"sudo dd if=" + $settings["jesta_settings"]["export_device_file"] + 
                 " of=" + $settings["jesta_settings"]["tmp_dir"] + "/" + $settings["jesta_settings"]["tmp_file"] + " bs=4096\""
            puts ssh.exec!("sudo dd if=" + $settings["jesta_settings"]["export_device_file"] + 
                           " of=" + $settings["jesta_settings"]["tmp_dir"] + "/" + $settings["jesta_settings"]["tmp_file"] + " bs=4096")
  
            puts "execute sudo fsfreeze -u /"
            puts ssh.exec!("sudo fsfreeze -u /")
          end
        rescue SystemCallError, Timeout::Error => e
          $logger.warn("unable to ssh" + host_name)
        end
 
        #TODO: compress img before scp

        # execute "scp orig.img (onpremisse server)"
        begin
          Net::SCP.start(host_name, user_name,
                         :keys => key_path) do |scp|
            puts "scp from " + $settings["jesta_settings"]["tmp_file"] + " to your local disk"
            scp.download!($settings["jesta_settings"]["tmp_dir"] +"/" + $settings["jesta_settings"]["tmp_file"], ".")
          end
        rescue SystemCallError, Timeout::Error => e
          $logger.warn("unable to scp" +  host_name)
        end
  
        # umount tmp device 
        begin
          Net::SSH.start(host_name, user_name,
                         :keys => key_path) do |ssh|
            puts "execute \"sudo umount " + $settings["jesta_settings"]["tmp_dir"] + "\""
            puts ssh.exec!("sudo umount " + $settings["jesta_settings"]["tmp_dir"])
          end
        rescue SystemCallError, Timeout::Error => e
          $logger.warn("unable to ssh" + host_name)
        end
  
        # detach tmp volume from instance
        attachment = tmp_volume.detach_from(@ec2.instances[export_instance], $settings["jesta_settings"]["tmp_device_file"])
  
        # wait until "detached"
        sleep 3 until tmp_volume.status == :available

        # delete tmp volume
        tmp_volume.delete
      end

      def get_debug_image()

      end

      def create_pvguest_config()
      end
      
      def start_initial_setting()
      end
  
      def change_root_password()
      end
    end
  end
end

