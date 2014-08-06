# Prerequisites

- AWS account access key and secret key.

# Jesta

Jesta is a tool to export Virtual Machine from EC2 with some useful options. 

## Installation

Add this line to your application's Gemfile:

    gem 'jesta'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jesta

## Usage

Don't use this tool without thinking license issues.

example1: To export instance.
bundle exec ruby bin/jesta export-instance --export_instance="****" --export_ebs="****" --os_type="****" --host_name="****" --user_name"=****" --key_path="****"

example2: To export instance with debug tools.
bundle exec ruby bin/jesta export-debug-instance --export_instance="****" --export_ebs="****" --os_type="****" --host_name="****" --user_name="****" --key_path="****" --kernel_version="****"


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
