require 'test_helper'

class UserSerializerTest < ActiveSupport::TestCase
  include Rails.application.routes.url_helpers

  setup do
    @user = users(:admin)
  end

  test 'serializes all visible attributes for a User' do
    %i(id email gravatar_url admin created_at updated_at).each do |attribute|
      assert_equal @user.send(attribute), serialized_user[attribute]
    end
  end

  test 'includes links for the User' do
    serialized_links = serialized_user[:links]
    assert_equal 2, serialized_links.count

    self_url = serialized_links.find { |url| url[:rel] == :self }
    refute_nil self_url
    assert_equal user_url(@user), self_url[:href]

    boards_url = serialized_links.find { |url| url[:rel] == :boards }
    refute_nil boards_url
    assert_equal user_boards_url(@user), boards_url[:href]
  end

  private

  def serialized_user(user = nil)
    user ||= @user
    UserSerializer.new(user).as_json
  end
end
