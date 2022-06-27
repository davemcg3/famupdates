def register_spec_helper(email, password, name, bio, username)
  click_on 'Register'
  fill_in 'user_email', with: email
  fill_in 'user_password', with: password
  fill_in 'user_password_confirmation', with: password
  click_on 'Sign up'
  expect(page).to have_text('New Profile')
  fill_in 'profile_name', with: name
  fill_in 'profile_bio', with: bio
  fill_in 'profile_username', with: username
  click_on 'Create Profile'
  expect(page).to have_text('Profile was successfully created.')
end

def login_spec_helper(email, password)
  click_on 'Login'
  fill_in 'user_email', with: email
  fill_in 'user_password', with: password
  click_on 'Log in'
end

def logout_spec_helper
  click_on 'Logout'
  expect(page).to have_text('Signed out successfully.')
end

def directly_create_user(email, password, name, bio, username)
  user = User.create!(email: email, password: password)
  profile = username.present? ? Profile.new(name: name, bio: bio, username: username) : Profile.new(name: name, bio: bio)
  profile.save!(validate: username.present?)
  ProfilesUser.new(user: user, profile: profile).save!
  user
end
