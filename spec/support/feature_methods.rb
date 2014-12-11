def sign_in
  click_on signin_path
  fill_in "Email", with: "test@example.com"
  fill_in "Password", with: "asdf"
  click_button "Sign in"
end
