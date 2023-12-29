require 'rails_helper'

RSpec.describe 'When I open post index page', type: :system do
  before :all do
    Like.delete_all
    Comment.delete_all
    Post.delete_all
    User.delete_all

    @first_user = User.create(name: 'Tom', photo: 'https://unsplash.com/photos/F_-0BxGuVvo',
                              bio: 'Teacher from Mexico.', posts_counter: 0)
    @second_user = User.create(name: 'Lilly', photo: 'https://unsplash.com/photos/F_-0BxGuVvo',
                               bio: 'Teacher from Poland.', posts_counter: 0)

    body = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore'

    @first_post = Post.create(author: @first_user, title: 'Title 1', text: body, comments_counter: 0, likes_counter: 0)
    Post.create(author: @first_user, title: 'Title 2', comments_counter: 0, likes_counter: 0)
    Post.create(author: @first_user, title: 'Title 3', comments_counter: 0, likes_counter: 0)
    Post.create(author: @first_user, title: 'Title 4', comments_counter: 0, likes_counter: 0)
    Post.create(author: @first_user, title: 'Title 5', comments_counter: 0, likes_counter: 0)

    (1..6).each do |i|
      Comment.create(user: @second_user, post: @first_post, text: "Comment #{i}")
    end

    10.times { Like.create(user: @second_user, post: @first_post) }
  end

  it 'shows the user\'s profile picture' do
    visit "/users/#{@first_user.id}/posts"
    expect(page).to have_css('img[alt="Tom"]')
  end

  it 'shows the user\'s username' do
    visit "/users/#{@first_user.id}/posts"
    expect(page).to have_content('Tom')
  end

  it 'shows total number of posts the user has written' do
    visit "/users/#{@first_user.id}/posts"
    expect(page).to have_content('Number of posts: 5')
  end

  it "shows a post's title" do
    visit "/users/#{@first_user.id}/posts"
    expect(page).to have_content('Title 2')
  end

  it "shows some of the post's body" do
    visit "/users/#{@first_user.id}/posts"
    body = 'This is my first post'
    expect(page).to have_content(body)
  end

  it 'shows the first comments on a post' do
    visit "/users/#{@first_user.id}/posts"
    expect(page).to have_content('Comment 3')
  end

  it 'shows how many comments a post has' do
    visit "/users/#{@first_user.id}/posts"
    expect(page).to have_content('Comments: 3')
  end

  it 'shows how many likes a post has' do
    visit "/users/#{@first_user.id}/posts"
    expect(page).to have_content('Likes: 1')
  end

  it 'shows pagination if there are more posts than it can fit on the view' do
    visit "/users/#{@first_user.id}/posts"
    expect(page).to have_link('2', href: "/users/#{@first_user.id}/posts?page=2")
  end

  context 'When I click on a post' do
    it 'redirects me to that post\'s show page' do
      visit "/users/#{@first_user.id}/posts"
      click_link('Title 1')
      expect(page).to have_current_path(user_post_path(@first_user, @first_post))
    end
  end
end
