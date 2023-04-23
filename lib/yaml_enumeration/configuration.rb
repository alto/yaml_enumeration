module YamlEnumeration
  class Configuration

    DEFAULT_PERMITTED_CLASSED = [].freeze

    class << self
      attr_writer :permitted_classes

      def permitted_classes
        @permitted_classes || DEFAULT_PERMITTED_CLASSED
      end
    end
  end
end
