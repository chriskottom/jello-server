require 'test_helper'

describe UsersController do
  before do
    @user = users(:admin)
  end

  describe 'GET /users' do
    it 'should successfully fetch all Users' do
      expected_users = User.all

      get users_url, as: :json
      assert_response :ok

      response_users = json_response['users']
      assert_instance_of Array, response_users

      assert_ids expected_users.pluck(:id), response_users, 'id'

      expected_keys = %w( id email gravatar_url admin created_at updated_at links )
      assert_keys expected_keys, response_users.first
    end
  end

  describe 'GET /users/:id' do
    it 'should successfully fetch the requested User' do
      get user_url(@user), as: :json
      assert_response :ok

      expected_keys = %w( id email gravatar_url admin created_at updated_at links 
                          active_boards )
      assert_keys expected_keys, response_user

      assert_equal @user.id, response_user['id']
      assert_equal @user.email, response_user['email']
      assert_equal @user.gravatar_url, response_user['gravatar_url']

      self_link = { 'rel' => 'self', 'href' => user_url(@user) }
      assert_link self_link, response_user, 'links'

      boards_link = { 'rel' => 'boards', 'href' => user_boards_url(@user) }
      assert_link boards_link, response_user, 'links'

      board_ids = @user.boards.where(archived: [false, nil]).pluck(:id)
      assert_ids board_ids, response_user['active_boards'], 'id'
    end

    describe 'when :id is unknown' do
      it 'should respond with :not_found' do
        get user_url(id: 'jim'), as: :json
        assert_response :not_found

        response_error = json_response['error']
        refute_nil response_error

        assert_equal 404, response_error['status']
        assert_equal 'Not found', response_error['name']
        refute_nil response_error['message']
      end
    end
  end

  describe 'POST /users' do
    it 'should create and respond with a new User' do
      user_attributes = {
        email: 'jim@example.com',
        password: 'secret',
        password_confirmation: 'secret'
      }

      assert_difference('User.count') do
        post users_url, params: { user: user_attributes }, as: :json
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
          post users_url, params: { user: user_attributes }, as: :json
        end

        assert_response :unprocessable_entity

        response_error = json_response['error']
        refute_nil response_error

        assert_equal 422, response_error['status']
        assert_equal 'Validation failed', response_error['name']

        response_errors = response_error['errors']
        assert_equal ["can't be blank"], response_errors['email']
        assert_equal ["can't be blank"], response_errors['password']
      end
    end
  end

  describe 'PATCH /users/:id' do
    it 'should update the requested User' do
      user_attributes = { email: 'jim@example.com' }

      update_time = 1.day.from_now.change(usec: 0)  # truncate milliseconds
      travel_to update_time

      patch user_url(@user), params: { user: user_attributes }, as: :json
      assert_response :ok

      assert_equal user_attributes[:email], response_user['email']
      assert_equal update_time.as_json, response_user['updated_at']

      travel_back
    end

    describe 'with invalid User attributes' do
      it 'should respond with validation errors' do
        user_attributes = { email: '' }

        assert_no_difference('User.count') do
          patch user_url(@user), params: { user: user_attributes }, as: :json
        end

        assert_response :unprocessable_entity

        response_error = json_response['error']
        refute_nil response_error

        assert_equal 422, response_error['status']
        assert_equal 'Validation failed', response_error['name']

        response_errors = response_error['errors']
        assert_equal ["can't be blank"], response_errors['email']
      end
    end

    describe 'when :id is unknown' do
      it 'should respond with :not_found' do
        user_attributes = { email: 'jim@example.com' }

        patch user_url(id: 'jim'), params: { user: user_attributes }, as: :json
        assert_response :not_found

        response_error = json_response['error']
        refute_nil response_error

        assert_equal 404, response_error['status']
        assert_equal 'Not found', response_error['name']
        refute_nil response_error['message']
      end
    end
  end

  describe 'DELETE /users/:id' do
    it 'should successfully delete the requested User' do
      assert_difference('User.count', -1) do
        delete user_url(@user), as: :json
      end

      assert_response :no_content
      assert_empty response.body
    end

    describe 'when :id is unknown' do
      it 'should respond with :not_found' do
        assert_no_difference('User.count') do
          delete user_url(id: 'jim'), as: :json
        end

        assert_response :not_found

        response_error = json_response['error']
        refute_nil response_error

        assert_equal 404, response_error['status']
        assert_equal 'Not found', response_error['name']
        refute_nil response_error['message']
      end
    end
  end

  private

  def response_user
    json_response['user']
  end
end
