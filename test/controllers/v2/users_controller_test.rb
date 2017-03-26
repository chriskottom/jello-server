require 'test_helper'

describe V2::UsersController do
  before do
    @user = users(:admin)
  end

  describe 'GET /v2/users' do
    it 'should successfully fetch all Users' do
      expected_users = User.all

      get v2_users_url, as: :json
      assert_response :ok

      response_users = json_response['users']
      assert_instance_of Array, response_users

      assert_ids expected_users.pluck(:id), response_users, 'id'

      expected_keys = %w( id email gravatar_url admin created_at updated_at links )
      assert_keys expected_keys, response_users.first
    end
  end

  describe 'GET /v2/users/:id' do
    it 'should successfully fetch the requested User' do
      get v2_user_url(@user), as: :json
      assert_response :ok

      expected_keys = %w( id email gravatar_url admin created_at updated_at links 
                          active_boards )
      assert_keys expected_keys, response_user

      assert_equal @user.id, response_user['id']
      assert_equal @user.email, response_user['email']
      assert_equal @user.gravatar_url, response_user['gravatar_url']

      self_link = { 'rel' => 'self', 'href' => v2_user_url(@user) }
      assert_link self_link, response_user, 'links'

      boards_link = { 'rel' => 'boards', 'href' => v2_user_boards_url(@user) }
      assert_link boards_link, response_user, 'links'

      board_ids = @user.boards.where(archived: [false, nil]).pluck(:id)
      assert_ids board_ids, response_user['active_boards'], 'id'
    end

    describe 'when :id is unknown' do
      it 'should respond with :not_found' do
        get v2_user_url(id: 'jim'), as: :json
        assert_not_found_response("Couldn't find User with 'id'=jim")
      end
    end
  end

  describe 'POST /v2/users' do
    it 'should create and respond with a new User' do
      user_attributes = {
        email: 'jim@example.com',
        password: 'secret',
        password_confirmation: 'secret'
      }

      assert_difference('User.count') do
        post v2_users_url, params: { user: user_attributes }, as: :json
      end

      assert_response :created

      expected_keys = %w( id email gravatar_url admin created_at updated_at
                          links active_boards archived_boards )
      assert_keys expected_keys, response_user

      assert_equal user_attributes[:email], response_user['email']
      refute_nil response_user['gravatar_url']

      assert_empty response_user['active_boards']
    end

    describe 'with invalid User attributes' do
      it 'should respond with validation errors' do
        user_attributes = { email: '' }

        assert_no_difference('User.count') do
          post v2_users_url, params: { user: user_attributes }, as: :json
        end

        expected_errors = { 'email' => ["can't be blank"],
                            'password' => ["can't be blank"] }
        assert_failed_validation_response expected_errors
      end
    end
  end

  describe 'PATCH /v2/users/:id' do
    it 'should update the requested User' do
      user_attributes = { email: 'jim@example.com' }

      update_time = 1.day.from_now.change(usec: 0)  # truncate milliseconds
      travel_to update_time

      patch v2_user_url(@user), params: { user: user_attributes }, as: :json
      assert_response :ok

      assert_equal user_attributes[:email], response_user['email']
      assert_equal update_time.as_json, response_user['updated_at']

      travel_back
    end

    describe 'with invalid User attributes' do
      it 'should respond with validation errors' do
        user_attributes = { email: '' }

        assert_no_difference('User.count') do
          patch v2_user_url(@user), params: { user: user_attributes }, as: :json
        end

        expected_errors = { 'email' => ["can't be blank"] }
        assert_failed_validation_response expected_errors
      end
    end

    describe 'when :id is unknown' do
      it 'should respond with :not_found' do
        user_attributes = { email: 'jim@example.com' }

        patch v2_user_url(id: 'jim'), params: { user: user_attributes }, as: :json

        assert_not_found_response("Couldn't find User with 'id'=jim")
      end
    end
  end

  describe 'DELETE /v2/users/:id' do
    it 'should successfully delete the requested User' do
      assert_difference('User.count', -1) do
        delete v2_user_url(@user), as: :json
      end

      assert_response :no_content
      assert_empty response.body
    end

    describe 'when :id is unknown' do
      it 'should respond with :not_found' do
        assert_no_difference('User.count') do
          delete v2_user_url(id: 'jim'), as: :json
        end

        assert_not_found_response("Couldn't find User with 'id'=jim")
      end
    end
  end

  private

  def response_user
    json_response['user']
  end
end
