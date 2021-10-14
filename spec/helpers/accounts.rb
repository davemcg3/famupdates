def register(email, password, name, bio)
  click_on 'Register'
  fill_in 'user_email', with: email
  fill_in 'user_password', with: password
  fill_in 'user_password_confirmation', with: password
  click_on 'Sign up'
  expect(page).to have_text('New Profile')
  fill_in 'profile_name', with: name
  fill_in 'profile_bio', with: bio
  click_on 'Create Profile'
  expect(page).to have_text('Profile was successfully created.')
end

def login(email, password)
  click_on 'Login'
  fill_in 'user_email', with: email
  fill_in 'user_password', with: password
  click_on 'Log in'
end

def logout
  click_on 'Logout'
  expect(page).to have_text('Signed out successfully.')
end

