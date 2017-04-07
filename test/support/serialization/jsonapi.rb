require_relative '../json_service.rb'

module Serialization
  module JSONAPI
    module Helpers
      def serialized_data(model, serializer_klass = nil)
        if !serializer_klass
          serializer_klass = ActiveModel::Serializer.serializer_for(model)
        end

        serializer = serializer_klass.new(model)
        adapter = ActiveModelSerializers::Adapter::JsonApi.new(serializer)
        adapter.as_json
      end

      def jsonapi_attributes(data)
        data.dig(:data, :attributes)
      end

      def jsonapi_links(data)
        data.dig(:data, :links)
      end

      def jsonapi_relationships(data)
        data.dig(:data, :relationships)
      end
    end

    module Assertions
      def assert_ids(ids, json_array, id_key = :id)
        actual_ids = json_array.map { |rec| rec.fetch(id_key).to_s }
        assert_equal ids.map(&:to_s).sort, actual_ids.sort
      end

      def assert_link(link_data, serialized_model, link_key = :links)
        link_hash = serialized_model[link_key]
        assert_includes link_hash, link_data
      end
    end

    module ControllerAssertions
      def assert_jsonapi_content_type
        assert_equal 'application/vnd.api+json', response.content_type
      end

      def assert_not_found_response(message = nil)
        assert_response :not_found

        error_data = json_response.dig('errors', 0)
        assert_equal '/data/attributes/id', error_data.dig('source', 'pointer')
        assert_equal 'not found', error_data['detail']
      end

      def assert_failed_validation_response(validations = {})
        assert_response :unprocessable_entity

        error_data = json_response.dig('errors')
        validations.each do |key, error_messages|
          error_messages.each do |message|
            expected_error = { 'source' => { 'pointer' => "/data/attributes/#{ key }" },
                               'detail' => message }
            assert_includes error_data, expected_error
          end
        end
      end
    end
  end
end
