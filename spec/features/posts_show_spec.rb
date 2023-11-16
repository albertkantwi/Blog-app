require 'rails_helper'
RSpec.describe 'When I open post show page', type: :system do
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
    (1..6).each do |i|
      Comment.create(user: @second_user, post: @first_post, text: "Comment #{i}")
    end
    10.times { Like.create(user: @second_user, post: @first_post) }
  end
  it "shows the post's title" do
    visit user_post_path(@first_user, @first_post)
    expect(page).to have_content('Title 1')
  end
  it 'shows who wrote the post' do
    visit user_post_path(@first_user, @first_post)
    expect(page).to have_content('by Tom')
  end
  it 'shows how many comments it has' do
    visit user_post_path(@first_user, @first_post)
    expect(page).to have_content('Comments: 6')
  end
  it 'shows how many likes it has' do
    visit user_post_path(@first_user, @first_post)
    expect(page).to have_content('Likes: 1')
  end
  it 'shows the post body' do
    visit user_post_path(@first_user, @first_post)
    body = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit'
    expect(page).to have_content(body)
  end
  it 'shows the username of each commentor' do
    visit user_post_path(@first_user, @first_post)
    expect(page).to have_text('Lilly:', count: 6)
  end
  it 'shows the comment each commentor left' do
    visit user_post_path(@first_user, @first_post)
    expect(page).to have_content('Comment 6')
  end
end