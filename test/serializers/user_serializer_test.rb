require 'test_helper'

class UserSerializerTest < ActiveSupport::TestCase
  setup do
    @user = users(:admin)
  end

  test 'serializes all visible attributes for a User' do
    serializer = UserSerializer.new(@user)
    serialized_user = serializer.as_json
    
    %i(id email gravatar_url admin created_at updated_at).each do |attribute|
      assert_equal @user.send(attribute), serialized_user[attribute]
    end
  end
end
