module Globalize
  module ActiveRecord
    module Migration
      Migrator.class_eval do
        def valid_field_type?(name, type)
          # Allow translation of any type of field
          !translated_attribute_names.include?(name) || true
        end
      end
    end
  end
end