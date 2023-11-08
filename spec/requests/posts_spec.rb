require 'rails_helper'

RSpec.describe 'Posts controller', type: :request do
  describe 'GET /users/user_id/posts' do
    before do
      user = User.create(name: 'Tom', posts_counter: 0)
      get user_posts_path(user)
    end

    it 'returns a 200 status code' do
      expect(response).to have_http_status(200)
    end

    it "renders the 'index' template" do
      expect(response).to render_template('index')
    end

    it "includes 'All posts' in the response body" do
      expect(response.body).to include('All posts')
    end
  end

  describe 'GET /users/user_id/posts/post_id' do
    before do
      user = User.create(name: 'Tom', posts_counter: 0)
      post = user.posts.create(title: 'All Post', comments_counter: 0, likes_counter: 0)
      get user_post_path(user, post)
    end

    it 'returns a 200 status code' do
      expect(response).to have_http_status(200)
    end

    it "renders the 'show' template" do
      expect(response).to render_template('show')
    end

    it "includes 'Specific post' in the response body" do
      expect(response.body).to include('Specific post')
    end
  end
end