require 'active_support/core_ext/class/attribute'

module YamlEnumeration
  class Enumeration

    extend Association

    class_attribute :values
    class_attribute :attributes
    class_attribute :all_instances

    attr_accessor :id

    def self.load_values(filename)
      file = File.join(Rails.root, 'db', 'enumerations', "#{filename}.yml")
      YAML.load(ERB.new(File.read(file)).result).values.each do |data|
        value data.symbolize_keys
      end
    end

    def self.value(hash)
      unless hash.key?(:id) && hash.key?(:type)
        raise "invalid definition"
      end

      self.attributes ||= Set.new
      self.attributes += hash.keys

      hash.keys.each do |attr|
        # defining getter method
        unless method_defined?(attr)
          define_method attr do
            self.class.values[id][attr]
          end
        end
        # defining question method
        unless method_defined?("#{attr}?")
          define_method "#{attr}?" do
            !!self.class.values[id][attr]
          end
        end
        # defining setter method
        unless method_defined?("#{attr}=")
          define_method "#{attr}=" do |v|
            self.class.values[id][attr] = v
          end
        end
      end

      self.values ||= {}
      self.values[hash[:id]] = hash
    end

    # def method_missing(name, *args, &block)
    #   if name[-1] == '=' && self.class.attributes.include?(name[0..-2].to_sym)
    #     self.class.values[id][name[0..-2].to_sym] = args.pop
    #   elsif name[-1] == '?' && self.class.attributes.include?(name[0..-2].to_sym)
    #     !!self.class.values[id][name[0..-2].to_sym]
    #   elsif self.class.attributes.include?(name.to_sym)
    #     self.class.values[id][name.to_sym]
    #   else
    #     super
    #   end
    # end

    def ==(other)
      other && id == other.id
    end

    def to_s
      "#{self.class}(#{self.class.values[id].inspect})"
    end

    class << self
      def all
        # values.keys.map {|id| new(id)} # override this if you do not want to keep associated obj loaded against
        self.all_instances ||= values.keys.map {|id| new(id)}
      end

      def find(id)
        case id
          when Integer
            all.detect {|a| a.id == id}
          when NilClass
            nil
          else
            all.detect {|a| a.type == id.to_s}
        end
      end
      alias_method :find_by_id, :find

      def find_by_type(type)
        all.detect {|a| a.type == type.to_s}
      end

      protected :new
    end # class << self

    private

    def initialize(id)
      self.id = id
    end

  end # Enumeration
end
