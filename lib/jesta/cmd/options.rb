require "optparse"

module Jesta
  module CMD
    # parse arguments
    module Options

      # parse arguments
      # @param [Array<String>]
      # @return [Hash]
      def self.parse!(argv)
        options = {}

        sub_command_parsers = opt_sub_command_parsers(options)
        command_parser = opt_command_parser

        begin
          command_parser.order! argv
          options[:command] = argv.shift
          sub_command_parsers[options[:command]].parse! argv
        rescue OptionParser::MissingArgument,
               OptionParser::InvalidOption,
               ArgumentError => e
          abort e.message
        end
        options
      end

      # OptionParser for sum-command
      # @param  [Hash]
      # @return [Hash<OptionParser>]
      def self.opt_sub_command_parsers(options)
        sub_command_parsers = Hash.new do |k, v|
          raise ArgumentError, "'#{v}' is not now available jesta."
        end

        # export instance from existing instance
        sub_command_parsers['export-instance'] = OptionParser.new do |opt|
          opt.banner = 'Usage: export-instance <args>'
          opt.on('--export_instance=VAL') {|v| options[:export_instance] = v }
          opt.on('--export_ebs=VAL') {|v| options[:export_ebs] = v }
          opt.on('--os_type=VAL') {|v| options[:os_type] = v }
          opt.on('--host_name=VAL') {|v| options[:host_name] = v }
          opt.on('--user_name=VAL') {|v| options[:user_name] = v }
          opt.on('--key_path=VAL') {|v| options[:key_path] = v }
          opt.on('-d VAL', '--detail=VAL', 'detail options') {|v| options[:content] = v }
          opt.on_tail('-h', '--help', 'sub-command help message') {|v| help_sub_command(opt) }
        end

        # export instance from existing instance with debug kernel
        sub_command_parsers['export-debug-instance'] = OptionParser.new do |opt|
          opt.banner = 'Usage: export-instance <args>'
          opt.on('--export_instance=VAL') {|v| options[:export_instance] = v }
          opt.on('--export_ebs=VAL') {|v| options[:export_ebs] = v }
          opt.on('--os_type=VAL') {|v| options[:os_type] = v }
          opt.on('--host_name=VAL') {|v| options[:host_name] = v }
          opt.on('--user_name=VAL') {|v| options[:user_name] = v }
          opt.on('--key_path=VAL') {|v| options[:key_path] = v }
          opt.on('--kernel_version=VAL') {|v| options[:kernel_version] = v }
          opt.on('-d VAL', '--detail=VAL', 'detail options') {|v| options[:content] = v }
          opt.on_tail('-h', '--help', 'sub-command help message') {|v| help_sub_command(opt) }

        end
        sub_command_parsers
      end

      # OptionParser for main command
      # @return [OptionsParser]
      def self.opt_command_parser
        OptionParser.new do |opt|
          sub_command_help = [
            {name: 'export-instance',
             summary: 'Export instance from existing instance'},
          ]

          opt.banner = "Usage: #{opt.program_name}
                  [-h|--help] [-v|--version] <command> [<args>]"
          opt.separator ''
          opt.separator "#{opt.program_name}'s sub-command"
          sub_command_help.each do |command|
            opt.separator [opt.summary_indent,
                  command[:name].ljust(40), command[:summary]].join(' ')
          end

          opt.on_head('-h', '--help', 'help message') do |v|
            puts opt.help
            exit
          end

          opt.on_head('-v', '--version', 'version of jesta') do |v|
            opt.version = Jesta::VERSION
            puts opt.ver
            exit
          end
        end
      end

      # parser for help
      # @param [OptionParser]
      def self.help_sub_command(parser)
        puts parser.help
        exit
      end

      private_class_method :opt_sub_command_parsers, :opt_command_parser, :help_sub_command
    end
  end
end
