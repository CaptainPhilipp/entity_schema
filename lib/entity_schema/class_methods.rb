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
            raise Exception, "class-level method `#{superclass}.entity_schema` is required " \
                              'by gem "entity_schema" and must return instance of ' \
                              "`#{Schema}`, but returns a `#{superschema.class}`"
          end

          Schema.new(owner_name: to_s).extends(superschema)
        else
          Schema.new(owner_name: to_s)
        end
      end
    end
    # rubocop:enable Metrics/MethodLength:
  end
end
