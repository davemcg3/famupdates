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
      register(email01, password01, name01, bio01, username01)
    end
  end

  context 'a logged out user' do
    it 'should not be able to visit a profile' do
      visit '/'
      register(email01, password01, name01, bio01, username01)
      click_on 'View Profile'
      profile_url = current_url
      logout
      visit profile_url
      expect(page).to have_button('Log in')
    end

    context 'with an incorrect or no password' do
      it 'should not be able to login' do
        visit '/'
        register(email01, password01, name01, bio01, username01)
        logout
        login email01, password01[0..4]
        expect(page).to have_text(error)
        login email01, ''
        expect(page).to have_text(error)
      end
    end

    context 'with the correct password' do
      it 'should be able to login' do
        visit '/'
        register(email01, password01, name01, bio01, username01)
        logout
        login email01, password01
        expect(page).to have_text('Logged-In Homepage')
      end
    end
  end

  context 'a logged in user' do
    it 'should be able to logout' do
      visit '/'
      register(email01, password01, name01, bio01, username01)
      logout
    end
  end
end
