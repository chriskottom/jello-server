require 'test_helper'

describe V3::UsersController do
  before do
    @user = users(:admin)
    @per_page = 3
  end

  describe 'GET /v3/users' do
    it 'should successfully fetch the first page of Users' do
      page = 1
      @expected_users = User.page(page).per(@per_page)
      get v3_users_url(page: { number: page, size: @per_page }),
          headers: auth_headers,
          as: :json

      assert_response :ok
      assert_equal 'application/json', response.content_type

      response_users = json_response['users']
      assert_instance_of Array, response_users
      assert_equal @per_page, response_users.count

      response_ids = response_users.map { |u| u['id'] }
      assert_equal @expected_users.ids.sort, response_ids.sort

      expected_keys = %w( id email gravatar_url admin created_at updated_at links )
      assert_ids @expected_users.pluck(:id), response_users, 'id'

      user_count = User.count
      response_meta = json_response.dig('meta')
      assert_equal page, response_meta['current_page']
      assert_equal page+1, response_meta['next_page']
      assert_nil response_meta['prev_page']
      assert_equal user_count, response_meta['total_count']
      assert_equal (user_count.to_f / @per_page.to_f).ceil,
                   response_meta['total_pages']
    end

    it 'should paginate the fetched Users' do
      page = 3
      @expected_users = User.page(page).per(@per_page)
      get v3_users_url(page: { number: page, size: @per_page }),
          headers: auth_headers,
          as: :json

      response_users = json_response['users']
      assert_ids @expected_users.pluck(:id), response_users, 'id'

      expected_keys = %w( id email gravatar_url admin created_at updated_at links )
      assert_keys expected_keys, response_users.first

      response_meta = json_response.dig('meta')
      assert_equal page, response_meta['current_page']
      assert_equal page+1, response_meta['next_page']
      assert_equal page-1, response_meta['prev_page']
    end

    describe 'when passed incorrect credentials' do
      it 'should respond with :unauthorized' do
        headers = auth_headers(username: 'FAIL', password: 'FAIL')
        get v3_users_url, headers: headers, as: :json
        assert_response :unauthorized

        assert_equal 'HTTP Basic: Access denied.',
                     json_response.dig('error', 'message')
      end
    end
  end

  describe 'GET /v3/users/:id' do
    it 'should successfully fetch the requested User' do
      get v3_user_url(@user), headers: auth_headers, as: :json
      assert_response :ok

      expected_keys = %w( id email gravatar_url admin created_at updated_at links
                          active_boards )
      assert_keys expected_keys, response_user

      assert_equal @user.id, response_user['id']
      assert_equal @user.email, response_user['email']
      assert_equal @user.gravatar_url, response_user['gravatar_url']

      self_link = { 'rel' => 'self', 'href' => v3_user_url(@user) }
      assert_link self_link, response_user, 'links'

      boards_link = { 'rel' => 'boards', 'href' => v3_user_boards_url(@user) }
      assert_link boards_link, response_user, 'links'

      board_ids = @user.boards.where(archived: [false, nil]).pluck(:id)
      assert_ids board_ids, response_user['active_boards'], 'id'
    end

    describe 'when :id is unknown' do
      it 'should respond with :not_found' do
        get v3_user_url(id: 'jim'), headers: auth_headers, as: :json
        assert_not_found_response("Couldn't find User with 'id'=jim")
      end
    end
  end

  describe 'POST /v3/users' do
    it 'should create and respond with a new User' do
      user_attributes = {
        email: 'jim@example.com',
        password: 'secret',
        password_confirmation: 'secret'
      }

      assert_difference('User.count') do
        post v3_users_url,
             headers: auth_headers,
             params: { user: user_attributes },
             as: :json
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
          post v3_users_url,
               headers: auth_headers,
               params: { user: user_attributes },
               as: :json
        end

        expected_errors = { 'email' => ["can't be blank"],
                            'password' => ["can't be blank"] }
        assert_failed_validation_response expected_errors
      end
    end
  end

  describe 'PATCH /v3/users/:id' do
    it 'should update the requested User' do
      user_attributes = { email: 'jim@example.com' }

      update_time = 1.day.from_now.change(usec: 0)  # truncate milliseconds
      travel_to update_time

      patch v3_user_url(@user),
            headers: auth_headers,
            params: { user: user_attributes },
            as: :json
      assert_response :ok

      assert_equal user_attributes[:email], response_user['email']
      assert_equal update_time.as_json, response_user['updated_at']

      travel_back
    end

    describe 'with invalid User attributes' do
      it 'should respond with validation errors' do
        user_attributes = { email: '' }

        assert_no_difference('User.count') do
          patch v3_user_url(@user),
                headers: auth_headers,
                params: { user: user_attributes },
                as: :json
        end

        expected_errors = { 'email' => ["can't be blank"] }
        assert_failed_validation_response expected_errors
      end
    end

    describe 'when :id is unknown' do
      it 'should respond with :not_found' do
        user_attributes = { email: 'jim@example.com' }

        patch v3_user_url(id: 'jim'),
              headers: auth_headers,
              params: { user: user_attributes },
              as: :json

        assert_not_found_response("Couldn't find User with 'id'=jim")
      end
    end
  end

  describe 'DELETE /v3/users/:id' do
    it 'should successfully delete the requested User' do
      assert_difference('User.count', -1) do
        delete v3_user_url(@user), headers: auth_headers, as: :json
      end

      assert_response :no_content
      assert_empty response.body
    end

    describe 'when :id is unknown' do
      it 'should respond with :not_found' do
        assert_no_difference('User.count') do
          delete v3_user_url(id: 'jim'), headers: auth_headers, as: :json
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
