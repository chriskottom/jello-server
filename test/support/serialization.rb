require_relative './json_service.rb'

module Serialization
  module Helpers
    def serialized_data(model, serializer_klass = nil)
      if !serializer_klass
        serializer_klass = ActiveModel::Serializer.serializer_for(model)
      end

      serializer = serializer_klass.new(model)
      serializer.as_json
    end
  end

  module Assertions
    def assert_keys(keys, hash)
      assert_equal keys.sort, hash.keys.sort
    end

    def assert_ids(ids, json_array, id_key = :id)
      actual_ids = json_array.map { |rec| rec.fetch(id_key) }
      assert_equal ids.sort, actual_ids.sort
    end

    def assert_link(link_data, serialized_model, link_key = :links)
      link_hash = serialized_model[link_key]
      assert_includes link_hash, link_data
    end
  end

  module ControllerAssertions
    include JSONService::Helpers

    def assert_error_response(attributes = { })
      serialized_error = json_response['error']
      refute_nil serialized_error

      attributes.each do |key, value|
        case value
        when Regexp
          assert_match value, serialized_error.fetch(key)
        else
          assert_equal value, serialized_error.fetch(key)
        end
      end
    end

    def assert_not_found_response(message = nil)
      assert_response :not_found
      error_attributes = { 'status' => 404, 'name' => 'Not found' }
      error_attributes['message'] = message if message
      assert_error_response(error_attributes)
    end

    def assert_failed_validation_response(validations = {})
      assert_response :unprocessable_entity
      assert_error_response('status' => 422, 'name' => 'Validation failed')

      validation_messages = json_response.dig('error', 'errors')
      validations.each do |key, error_messages|
        assert_equal error_messages, validation_messages[key]
      end
    end

    def assert_unauthorized_response(message = nil)
      assert_response :unauthorized
      error_attributes = { 'status' => 401, 'name' => 'Unauthorized' }
      error_attributes['message'] = message if message
      assert_error_response(error_attributes)
    end
  end
end
