require 'amigrind/core/version'
require 'amigrind/core/logging'

require 'aws-sdk'
require 'json'

# Pre-include
module Amigrind
  module Core
  end
end

Dir["#{__dir__}/**/*.rb"].each { |f| require_relative f }

# Post-include
module Amigrind
  module Core
    AMIGRIND_NAME_TAG = 'amigrind:Blueprint'.freeze
    AMIGRIND_ID_TAG = 'amigrind:Id'.freeze
    AMIGRIND_CHANNEL_TAG = 'amigrind:channel:%{channel_name}'.freeze
    AMIGRIND_PARENT_NAME_TAG = 'amigrind:ParentBlueprint'.freeze
    AMIGRIND_PARENT_ID_TAG = 'amigrind:ParentId'.freeze

    BLUEPRINT_NAME_REGEX = /[a-z0-9_\.]{2,24}/

    VPC_REGEX = /vpc-[0-9a-f]{8}/
    SUBNET_REGEX = /subnet-[0-9a-f]{8}/
    AMI_REGEX = /ami-[0-9a-f]{8}/
    SG_REGEX = /sg-[0-9a-f]{8}/
  end
end
