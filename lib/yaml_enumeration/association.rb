# frozen_string_literal: true

module YamlEnumeration
  module Association
    def belongs_to_enumeration(enumeration, options={})
      class_name = options[:class_name] || enumeration

      define_method(enumeration) do
        local_instance = instance_variable_get("@#{enumeration}")
        local_id = send("#{enumeration}_id")
        if local_instance && local_instance.id == local_id
          local_instance
        else
          instance_variable_set("@#{enumeration}",
                                local_id && class_name.to_s.classify.constantize.find_by_id(local_id))
        end
      end

      define_method("#{enumeration}=") do |instance|
        send("#{enumeration}_id=", instance.try(:id))
      end
    end
  end
end
