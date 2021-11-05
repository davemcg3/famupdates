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
  edited_text = 'edited text'

  context 'with a valid profile' do
    it 'should be able to create a status update' do
      visit '/'
      register(email01, password01, name01, bio01, username01)
      create_status(status01)
      create_status(status02)
      expect(page).not_to have_text(status01)
      expect(page).to have_text(status02)
      click_on 'View Profile'
      click_on 'View Past Statuses'
      expect(page).to have_text(status01)
      expect(page).to have_text(status02)
    end

    it 'should be able to edit own status update' do
      visit '/'
      register(email01, password01, name01, bio01, username01)
      create_status(status01)
      create_status(status02)
      click_on 'View Profile'
      click_on 'View Past Statuses'
      within '#past_statuses' do
        click_on 'Edit', match: :first
      end
      fill_in 'status_content', with: edited_text
      within '.actions' do
        click_on 'Update Status'
      end
      expect(page).to have_text('Status was successfully updated.')
      expect(page).to have_text("Content: #{edited_text}")
    end

    it 'should be able to delete own status update' do
      visit '/'
      register(email01, password01, name01, bio01, username01)
      create_status(status01)
      click_on 'View Profile'
      click_on 'View Past Statuses'
      within '#past_statuses' do
        click_on 'Destroy', match: :first
      end
      page.driver.browser.switch_to.alert.accept
      expect(page).not_to have_text(status01)
      expect(page).to have_text('Status was successfully destroyed.')
    end

    it 'should be able to create a wall post' do
      visit '/'
      register(email01, password01, name01, bio01, username01)
      create_status(status01)
      create_status(status02)
      logout
      register(email02, password02, name02, bio02, username02)
      expect(page).to have_text(bio01)
      click_on name01
      create_post(post01)
    end

    it 'should be able to edit authored wall post' do
      visit '/'
      register(email01, password01, name01, bio01, username01)
      create_status(status01)
      create_status(status02)
      logout
      register(email02, password02, name02, bio02, username02)
      expect(page).to have_text(bio01)
      click_on name01
      create_post(post01)
      within '#wall_posts' do
        click_on 'Edit'
      end
      fill_in 'post_content', with: edited_text
      within '.actions' do
        click_on 'Update Post'
      end
      expect(page).to have_text('Post was successfully updated.')
      expect(page).to have_text("Content: #{edited_text}")
    end

    it 'should be able to delete authored wall post' do
      visit '/'
      register(email01, password01, name01, bio01, username01)
      create_status(status01)
      logout
      register(email02, password02, name02, bio02, username02)
      expect(page).to have_text(bio01)
      click_on name01
      create_post(post01)
      within '#wall_posts' do
        click_on 'Destroy'
      end
      page.driver.browser.switch_to.alert.accept
      expect(page).not_to have_text(post01)
      expect(page).to have_text('Post was successfully destroyed.')
    end

    it 'should be able to follow and unfollow another user' do
      visit '/'
      register(email01, password01, name01, bio01, username01)
      create_status(status01)
      create_status(status02)
      logout
      register(email02, password02, name02, bio02, username02)
      expect(page).to have_text(bio01)
      follow
      expect(page).to have_text("Bio: #{bio01}")
      click_on 'fam updates'
      expect(page).to have_text(status02)
      click_on 'Find New Fam'
      unfollow
      click_on 'fam updates'
      expect(page).not_to have_text(status02)
    end

    it 'should be able to block and unblock another user' do
      visit '/'
      register(email01, password01, name01, bio01, username01)
      create_status(status01)
      create_status(status02)
      logout
      register(email02, password02, name02, bio02, username02)
      expect(page).to have_text(bio01)
      follow
      block
      expect(page).to have_text("You are blocking this user.")
      click_on 'fam updates'
      expect(page).not_to have_text(status02)
      visit profile_path(Profile.first.id)
      unblock
      click_on 'fam updates'
      expect(page).to have_text(status02)
    end

    it 'should show the most recent status of profiles following upon login' do
      visit '/'
      register(email01, password01, name01, bio01, username01)
      create_status(status01)
      create_status(status02)
      logout
      register(email02, password02, name02, bio02, username02)
      expect(page).to have_text(bio01)
    end

    it 'should show users being followed even if they do not have a status' do
      visit '/'
      register(email01, password01, name01, bio01, username01)
      logout
      register(email02, password02, name02, bio02, username02)
      click_on 'Follow'
      click_on 'View Fam Statuses'
      expect(page).to have_text(name01)
    end

    it 'should allow user to view own profile' do
      visit '/'
      register(email01, password01, name01, bio01, username01)
      click_on 'View Profile'
      expect(page).to have_text(name01)
      expect(page).to have_text(bio01)
      expect(page).to have_text(username01)
    end

    it 'profile should be accessible with a username' do
      visit '/'
      register(email01, password01, name01, bio01, username01)
      visit "/profiles/#{username01}"
      expect(page).to have_text(name01)
      expect(page).to have_text(bio01)
      expect(page).to have_text(username01)
    end

    # Probably can remove this functionality once all users have a username
    it 'profile should be fallback accessible with an id' do
      user = directly_create_user(email01, password01, name01, bio01, '')
      profile = user.profiles.first
      visit '/'
      login(email01, password01)
      visit "/profiles/#{profile.id}"
      expect(page).to have_text(name01)
      expect(page).to have_text(bio01)
    end

    it 'non-existent username should trigger a 404' do
      user = directly_create_user(email01, password01, name01, bio01, username01)
      visit '/'
      login(email01, password01)
      expect {
        visit "/profiles/#{username01 + 'boogabooga'}"
      }.to raise_error(ActionController::RoutingError)
      byebug
    end

    it 'non-existent id should trigger a 404' do
      user = directly_create_user(email01, password01, name01, bio01, username01)
      visit '/'
      login(email01, password01)
      visit "/profiles/#{profile.id + 100}"
      byebug
    end

    it 'should allow user to find additional profiles' do
      visit '/'
      register(email01, password01, name01, bio01, username01)
      logout
      register(email02, password02, name02, bio02, username02)
      click_on 'Find New Fam'
      expect(page).to have_text(name01)
      expect(page).to have_text(bio01)
      expect(page).to have_text(username01)
      expect(page).to have_button('Follow')
      expect(page).to have_button('Block')
    end
  end
end
