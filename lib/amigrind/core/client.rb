require 'aws-sdk'

module Amigrind
  module Core
    class Client
      # IDEA: future enhancement - maybe have an optional caching server that
      #       Amigrind clients can hit for quicker responses? because this is
      #       pretty slow when it has to hit the API for read requests.
      attr_reader :region
      attr_reader :credentials

      def initialize(region, credentials)
        raise "'region' must be a String or nil." unless region.is_a?(String) || region.nil?
        raise "'credentials' (#{credentials}) must be nil, an Aws::Credentials, or an Aws::CredentialProvider." \
          unless credentials.nil? ||
                 credentials.class.ancestors.include?(Aws::CredentialProvider) ||
                 credentials.is_a?(Aws::Credentials)

        @region = region
        @credentials = credentials

        ec2_opts = { region: region, credentials: credentials }.delete_if { |k, v| v.nil? }

        @ec2 = Aws::EC2::Client.new(ec2_opts)
        @ec2_rsrc = Aws::EC2::Resource.new(client: @ec2)
      end

      def get_image_by_id(name:, id:)
        raise "'name' must be a String." unless name.is_a?(String)
        raise "'id' must be a Fixnum." unless id.is_a?(Fixnum)

        find_images_for_tags(
          Amigrind::Core::AMIGRIND_NAME_TAG => name,
          Amigrind::Core::AMIGRIND_ID_TAG => id.to_s
        ).first
      end

      def get_image_by_channel(name:, channel:, steps_back: 0)
        raise "'name' must be a String." unless name.is_a?(String)
        raise "'channel' must be a String or Symbol." \
          unless channel.is_a?(Symbol) || channel.is_a?(String)
        raise "'steps_back' must be a Fixnum." unless steps_back.is_a?(Fixnum)

        channel = channel.to_sym

        tags = {
          Amigrind::Core::AMIGRIND_NAME_TAG => name
        }

        if channel != :latest
          channel_tag =
            Amigrind::Core::AMIGRIND_CHANNEL_TAG % { channel_name: channel }
          tags[channel_tag] = 1
        end

        images = find_images_for_tags(tags.delete_if { |_, v| v.nil? })
        images.sort { |a, b| a.creation_date <=> b.creation_date }.reverse[steps_back]
      end

      def get_images(name:)
        raise "'name' must be a String." unless name.is_a?(String)

        find_images_for_tags(
          Amigrind::Core::AMIGRIND_NAME_TAG => name
        )
      end

      private

      def find_images_for_tags(tags)
        raise "tags must be a Hash." unless tags.is_a?(Hash)

        @ec2_rsrc.images(
          filters:
            [{ name: 'image-type', values: [ 'machine' ] }] +
            tags.map do |name, values|
              {
                name: "tag:#{name}",
                values: [ values ].flatten.map { |i| i.to_s }
              }
            end).map(&:itself)
      end
    end
  end
end
