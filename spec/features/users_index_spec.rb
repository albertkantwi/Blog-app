require 'rails_helper'
RSpec.describe 'When I open user index page', type: :system do
  before :all do
    Like.delete_all
    Comment.delete_all
    Post.delete_all
    User.delete_all
    @first_user = User.create(name: 'Tom', photo: 'https://unsplash.com/photos/F_-0BxGuVvo',
                              bio: 'Teacher from Mexico.', posts_counter: 2)
    @second_user = User.create(name: 'Lilly', photo: 'https://unsplash.com/photos/F_-0BxGuVvo',
                               bio: 'Teacher from Poland.', posts_counter: 0)
  end
  it 'shows the usernames of the users' do
    visit users_path
    expect(page).to have_text(@first_user.name)
    expect(page).to have_text(@second_user.name)
  end
  it 'shows profile photos of each users' do
    visit users_path
    expect(page).to have_css('img[alt="Tom"]')
    expect(page).to have_css('img[alt="Lilly"]')
  end
  it 'shows the number of posts each user has written' do
    visit users_path
    expect(page).to have_content('Number of posts: 0')
    expect(page).to have_content('Number of posts: 0')
  end
  it 'redirects to the user\'s show page' do
    visit users_path
    click_link(href: user_path(@first_user))
    expect(page).to have_current_path(user_path(@first_user))
  end
end
