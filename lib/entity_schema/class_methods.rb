# frozen_string_literal: true

require_relative 'schema'

module EntitySchema
  # TODO: doc
  module ClassMethods
    # rubocop:disable Metrics/MethodLength:
    def entity_schema
      @entity_schema ||= begin
        if superclass.respond_to?(:entity_schema)
          superschema = superclass.entity_schema

          unless superschema.is_a?(Schema)
            raise Exception, 'method `.entity_schema` is required by gem "entity_schema" ' \
                              'and must return instance of `EntitySchema::Schema`, ' \
                              "but returns a `#{superschema.class}`"
          end

          Schema.new(owner: self).extends(superschema)
        else
          Schema.new(owner: self)
        end
      end
    end
    # rubocop:enable Metrics/MethodLength:
  end
end
