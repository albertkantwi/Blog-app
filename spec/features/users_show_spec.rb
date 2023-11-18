require 'rails_helper'

RSpec.describe 'When I open user show page', type: :system do
  before :all do
    Like.delete_all
    Comment.delete_all
    Post.delete_all
    User.delete_all

    @first_user = User.create(name: 'Tom', photo: 'https://unsplash.com/photos/F_-0BxGuVvo',
                              bio: 'Teacher from Mexico.', posts_counter: 0)
    @second_user = User.create(name: 'Lilly', photo: 'https://unsplash.com/photos/F_-0BxGuVvo',
                               bio: 'Teacher from Poland.', posts_counter: 0)

    Post.create(author: @first_user, title: 'Title 1', comments_counter: 0, likes_counter: 0)
    Post.create(author: @first_user, title: 'Title 2', comments_counter: 0, likes_counter: 0)
    @third_post = Post.create(author: @first_user, title: 'Title 3', comments_counter: 0, likes_counter: 0)
    Post.create(author: @first_user, title: 'Title 4', comments_counter: 0, likes_counter: 0)
    Post.create(author: @second_user, title: 'Title 1', comments_counter: 0, likes_counter: 0)
    Post.create(author: @second_user, title: 'Title 2', comments_counter: 0, likes_counter: 0)
  end

  it 'shows the photos of users' do
    visit user_path(@first_user)
    expect(page).to have_css('img[alt="photo"]')
  end

  it 'shows the user\'s name' do
    visit user_path(@first_user)
    expect(page).to have_content('Tom')
  end

  it 'shows the number of posts the user has written' do
    visit user_path(@first_user)
    expect(page).to have_content('Number of posts: 8')
  end

  it 'shows the bio' do
    visit user_path(@first_user)
    expect(page).to have_content('Teacher from Mexico.')
  end

  it 'shows the fist three posts' do
    visit user_path(@first_user)
    expect(page).to have_content('Title 1')
    expect(page).to have_content('Title 2')
    expect(page).to have_content('Title 3')
  end

  it 'shows the view all post button' do
    visit user_path(@first_user)
    expect(page).to have_link('See All Posts')
  end

  context 'When I click a user\'s post' do
    it 'redirects me to that post\'s show page' do
      visit user_path(@first_user)
      click_link('Title 3')
      expect(page).to have_current_path(user_post_path(@first_user, @third_post))
    end
  end

  context 'When I click to see all posts' do
    it 'redirects me to the user\'s post\'s index page' do
      visit user_path(@first_user)
      click_link('See All Posts')
      expect(page).to have_current_path("/users/#{@first_user.id}/posts")
    end
  end
end
