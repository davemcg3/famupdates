require 'rails_helper'
require 'helpers/accounts'
require 'helpers/profiles'

RSpec.describe 'Basic Account Actions' do
  email01 = 'test01@test.com'
  password01 = '123456'
  name01 = 'test 01'
  bio01 = 'test 01 bio'
  username01 = 'test01'
  error = 'Invalid Email or password.'

  context 'a visitor without an account' do
    it 'should be able to register and create a profile' do
      visit '/'
      register_spec_helper(email01, password01, name01, bio01, username01)
    end

    it 'should not be able to create a profile without a username' do
      visit '/'
      click_on 'Register'
      fill_in 'user_email', with: email01
      fill_in 'user_password', with: password01
      fill_in 'user_password_confirmation', with: password01
      click_on 'Sign up'
      expect(page).to have_text('New Profile')
      fill_in 'profile_name', with: name01
      fill_in 'profile_bio', with: bio01
      click_on 'Create Profile'
      expect(page).to have_text('Username can\'t be blank')
    end

    it 'existing profiles without a username should go to edit profile on login' do
      directly_create_user(email01, password01, name01, bio01, '')
      visit '/'
      login_spec_helper(email01, password01)
      expect(page).to have_text('Editing Profile')
    end
  end

  context 'a logged out user' do
    it 'should not be able to visit a profile' do
      visit '/'
      register_spec_helper(email01, password01, name01, bio01, username01)
      click_on 'View Profile'
      profile_url = current_url
      logout_spec_helper
      visit profile_url
      expect(page).to have_button('Log in')
    end

    context 'with an incorrect or no password' do
      it 'should not be able to login' do
        visit '/'
        register_spec_helper(email01, password01, name01, bio01, username01)
        logout_spec_helper
        login_spec_helper email01, password01[0..4]
        expect(page).to have_text(error)
        login_spec_helper email01, ''
        expect(page).to have_text(error)
      end
    end

    context 'with the correct password' do
      it 'should be able to login' do
        visit '/'
        register_spec_helper(email01, password01, name01, bio01, username01)
        logout_spec_helper
        login_spec_helper email01, password01
        expect(page).to have_text('Logged-In Homepage')
      end
    end
  end

  context 'a logged in user' do
    it 'should be able to logout' do
      visit '/'
      register_spec_helper(email01, password01, name01, bio01, username01)
      logout_spec_helper
    end
  end
end
