# frozen_string_literal: true

require 'rails/railtie'

module YamlEnumeration
  class Railtie < Rails::Railtie
    initializer "extending ActiveRecord with YamlEnumeration" do
      ActiveRecord::Base.extend(YamlEnumeration::Association)
    end
  end
end
