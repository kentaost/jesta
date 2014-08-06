require 'spec_helper'

require 'jesta/cmd'
require 'jesta/settings'
require 'jesta/cmd/export'
require 'logger'
require 'time'

describe Jesta::CMD::Export do

  before(:all) do
    $settings = Jesta::Settings.load_config("settings.yml")
    $logger = Logger.new($settings["system_config"]["logger_path"])

    @exp = Jesta::CMD::Export.new
  end

  it "export image from existing instance" do
    # create test instance

    # add test text

    # execute "export_from_instance"

    # mount test.img

    # check test text
    #res.should match("test by jesta: export image from existing instance")
  end

  it "export image from existing instance with debug kernel" do

  end
end
