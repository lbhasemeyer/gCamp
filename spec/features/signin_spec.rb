require 'rails_helper'

feature "signin" do
  scenario "User signs into gCamp" do
    User.create!(
      first_name: "Mr",
      last_name: "Bean",
      email: "mr@bean.com",
      password: "bean",
      password_confirmation: "bean"
      )
    visit root_path
    click_on("Sign In")
    click_button("Sign in")
    expect(page).to have_content("Username / password combination is invalid")

    fill_in "Email", with: "mr@bean.com"
    fill_in "Password", with: "bean"
    click_button("Sign in")
    expect(current_path).to eq projects_path
    expect(page).to have_content("Mr Bean")
    expect(page).to have_content("Sign Out")
    expect(page).to have_no_content("Sign In")
    expect(page).to have_no_content("Sign Up")

    click_on("Mr Bean")
    expect(page).to have_content("Mr Bean")
    expect(page).to have_content("First Name: Mr")
    expect(page).to have_content("Last Name: Bean")
    expect(page).to have_content("Email: mr@bean.com")
end

end
