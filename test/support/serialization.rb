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
end
