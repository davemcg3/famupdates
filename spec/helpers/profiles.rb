def create_status(status)
  click_on 'Update Your Status'
  fill_in 'status_content', with: status
  click_on 'Create Status'
  expect(page).to have_text(status)
end

def create_post(content)
  click_on 'Leave Message'
  fill_in 'post_content', with: content
  click_on 'Create Post'
  expect(page).to have_text(content)
end

def follow
  click_on 'Follow'
  expect(page).to have_button("Unfollow")
end

def unfollow
  click_on 'Unfollow'
  expect(page).to have_button("Follow")
end

def block
  click_on 'Block'
  expect(page).to have_button("Unblock")
end

def unblock
  click_on 'Unblock'
  expect(page).to have_button("Block")
end
