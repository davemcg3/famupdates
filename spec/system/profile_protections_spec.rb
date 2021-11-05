require 'rails_helper'
require 'helpers/accounts'
require 'helpers/profiles'

RSpec.describe 'Profile Actions' do
  email01 = 'test01@test.com'
  password01 = '123456'
  name01 = 'test 01'
  bio01 = 'test 01 bio'
  username01 = 'test01'
  status01 = 'test 01 first status'
  status02 = 'test 02 second status'
  post01 = 'Wall message'
  email02 = 'test02@test.com'
  password02 = '123456'
  name02 = 'test 02'
  bio02 = 'test 02 bio'
  username02 = 'test02'

  context "destruction of other people's property" do
    before do
      visit '/'
      register(email01, password01, name01, bio01, username01)
      create_status(status01)
      logout
      register(email02, password02, name02, bio02, username02)
      expect(page).to have_text(bio01)
    end

    # TODO: this is a bad test, will likely need to test this through another means
    xit "should not be able to destroy another user's status" do
      visit statuses_path
      expect(page).not_to have_link('Destroy')
      status = Status.last
      # Not a good way to write this spec but the UI doesn't allow you to get here
      delete "/statuses/#{status.id}"
      expect(response.status).to eq(302)
      expect(status.destroyed?).to be_falsey
    end

    # TODO: this is a bad test, leave UI verification of ability not exposed, move functionality to API test
    xit "should not be able to destroy another user's wall post" do
      click_on name01
      create_post(post01)
      logout
      login email01, password01
      post = Post.last
      # Not a good way to write this spec but the UI doesn't allow you to get here
      delete "/posts/#{post.id}"
      # click_on 'View Profile'
      # within '#wall_posts' do
      #   click_on 'Destroy', match: :first
      # end
      # page.driver.browser.switch_to.alert.accept
      expect(response.status).to eq(302)
      expect(post.destroyed?).to be_falsey
    end

    # TODO: this is a bad test, leave UI verification of ability not exposed, move functionality to API test
    it "should not be able to destroy another user's profile" do
      visit profiles_path
      expect(page).not_to have_link('Destroy')
      profile = Profile.first
      # Not a good way to write this spec but the UI doesn't allow you to get here
      delete "/profiles/#{profile.id}"
      expect(response.status).to eq(302)
      expect(profile.destroyed?).to be_falsey
    end
  end

  context "editing of other people's property" do
    before do
      visit '/'
      register(email01, password01, name01, bio01, username01)
      create_status(status01)
      logout
      register(email02, password02, name02, bio02, username02)
      expect(page).to have_text(bio01)
    end

    it "should not be able to edit another user's status" do
      visit statuses_path
      expect(page).not_to have_link('Edit')
      visit edit_status_path(Status.last)
      expect(page).not_to have_button('Update Status')
      expect(page).to have_text('You cannot edit this status!')
    end

    it "should not be able to edit another user's wall post" do
      click_on name01
      create_post(post01) # TODO: Capture post id here to use later in test
      logout
      login email01, password01
      # Not a good way to write this spec but the UI doesn't allow you to get here
      # Post.last.id will potentially fail or fail to properly test when tests are parallelized in CI/CD
      visit edit_post_path(Post.last.id, profile_id: Profile.find_by(name: name01).id)
      # click_on 'View Profile'
      # within '#wall_posts' do
      #   click_on 'Edit', match: :first
      # end
      expect(page).not_to have_button('Update Post')
      expect(page).to have_text('You cannot edit this post!')
    end

    it "should not be able to edit another user's profile" do
      visit profiles_path
      expect(page).not_to have_link('Edit')
      visit edit_profile_path(Profile.first)
      expect(page).not_to have_button('Update Profile')
      expect(page).to have_text('You cannot edit this profile!')
    end
  end
end
