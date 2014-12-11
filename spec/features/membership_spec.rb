require 'rails_helper'

  feature "memberships" do

    before do
        User.create!(
          first_name: "Barry",
          last_name: "Bonds",
          email: "base@ball.com",
          password: "baseball",
          password_confirmation: "baseball"
        )
        user = User.create!(
          first_name: "Elmer",
          last_name: "Fudd",
          email: "elmer@fudd.com",
          password: "wabbit",
          password_confirmation: "wabbit"
        )
         visit signin_path
         fill_in "Email", with: "elmer@fudd.com"
         fill_in "Password", with: "wabbit"
         click_button "Sign in"
         click_on "Create Project"
         fill_in "Name", with: "Scale Mountain on Pogo Stick"
         click_button "Create Project"
      end

    scenario "Link to projects memberships index appears on the project show page" do
      page.all(:link,"Scale Mountain on Pogo Stick")[1].click
      expect(page).to have_content "Scale Mountain on Pogo Stick"
      click_on("1 Membership")
    end

    scenario "Users must enter users and roles for memberships" do
      visit projects_path
      page.all(:link,"Scale Mountain on Pogo Stick")[1].click
      click_on("1 Membership")
      click_on("Add New Member")
      expect(page).to have_content("User can't be blank")
    end

    scenario "Users can add members to projects" do
      visit projects_path
      page.all(:link,"Scale Mountain on Pogo Stick")[1].click
      click_on("1 Membership")
      within ".table" do
        expect(page).to have_no_content("Barry Bonds")
      end
      within ".well" do
        select "Barry Bonds", from: "membership_user_id"
        select "Member", from: "membership_title"
      end
      click_on("Add New Member")
      expect(page).to have_content("Barry Bonds was added successfully.")
      within ".table" do
        expect(page).to have_content("Barry Bonds")
        expect(page).to have_content("Member")
        expect(page).to have_button("Update")
      end
    end

  scenario "Users cannot add the same member to a project twice" do
    visit projects_path
    page.all(:link,"Scale Mountain on Pogo Stick")[1].click
    click_on("1 Membership")
    within ".well" do
      select "Barry Bonds", from: "membership_user_id"
      select "Member", from: "membership_title"
    end
    click_on("Add New Member")
    within ".well" do
      select "Barry Bonds", from: "membership_user_id"
      select "Owner", from: "membership_title"
    end
    click_on("Add New Member")
    expect(page).to have_content("User has already been added")
  end

  scenario "Users can be added to multiple projects" do
    visit projects_path
    click_on "Create Project"
    fill_in "Name", with: "Make River of Cheese"
    click_button "Create Project"
    visit projects_path
    page.all(:link,"Scale Mountain on Pogo Stick")[1].click
    click_on("1 Membership")
    within ".well" do
      select "Barry Bonds", from: "membership_user_id"
      select "Member", from: "membership_title"
    end
    click_on("Add New Member")
    expect(page).to have_content("Barry Bonds was added successfully.")
    visit projects_path
    page.all(:link,"Make River of Cheese")[1].click
    click_on("1 Membership")
    within ".well" do
      select "Barry Bonds", from: "membership_user_id"
      select "Member", from: "membership_title"
    end
    click_on("Add New Member")
    expect(page).to have_content("Barry Bonds was added successfully.")
  end

  scenario "Users see breadcrumbs on the memberships index and project show" do
    visit projects_path
    page.all(:link,"Scale Mountain on Pogo Stick")[1].click
    within ".breadcrumb" do
      click_on("Projects")
    end
    expect(page).to have_content("Projects")
    expect(current_path).to eq projects_path

    visit projects_path
    page.all(:link,"Scale Mountain on Pogo Stick")[1].click
    click_on("1 Membership")
    within ".breadcrumb" do
      click_on("Scale Mountain on Pogo Stick")
    end
    expect(page).to have_content("Scale Mountain on Pogo Stick")
    click_on("1 Membership")
    within ".breadcrumb" do
      click_on("Projects")
    end
    expect(page).to have_content("Projects")
    expect(current_path).to eq projects_path
  end

  scenario "Users can change the role of project members" do
    visit projects_path
    page.all(:link,"Scale Mountain on Pogo Stick")[1].click
    click_on("1 Membership")
    within ".table" do
      expect(page).to have_no_content("Barry Bonds")
    end
    within ".well" do
      select "Barry Bonds", from: "membership_user_id"
      select "Member", from: "membership_title"
    end
    click_on("Add New Member")
    within('table.table tr', text: "Barry Bonds") do
      select "Owner"
      click_on("Update")
    end
    expect(page).to have_content("Barry Bonds was updated successfully.")
    within('table.table tr', text: "Elmer Fudd") do
      select "Member"
      click_on("Update")
    end
    expect(page).to have_content("Elmer Fudd was updated successfully.")
  end

  scenario "Users can remove project members" do
    visit projects_path
    page.all(:link,"Scale Mountain on Pogo Stick")[1].click
    click_on("1 Membership")
    within ".well" do
      select "Barry Bonds", from: "membership_user_id"
      select "Owner", from: "membership_title"
    end
    click_on("Add New Member")
    within('table.table tr', text: "Barry Bonds") do
      find(".glyphicon").click
    end
    expect(page).to have_content "Barry Bonds was removed successfully."
  end

  end
