require 'rails_helper'

  feature "memberships" do
    before do
      project = Project.create!(
        name: "Scale Mountain on Pogo Stick"
      )
      user = User.create!(
        first_name: "Elmer",
        last_name: "Fudd",
        email: "elmer@fudd.com",
        password: "wabbit",
        password_confirmation: "wabbit"
      )
    end

    scenario "Link to projects memberships index appears on the project show page" do
      visit projects_path
      expect(page).to have_content("0")
      page.all(:link,"0")[0].click
      expect(page).to have_content "Scale Mountain on Pogo Stick"
    end

    scenario "Users must enter users and roles for memberships" do
      visit projects_path
      page.all(:link,"0")[0].click
      click_on "Add New Member"
      expect(page).to have_content("User can't be blank")
    end

    scenario "Users can add members to projects" do
      visit projects_path
      page.all(:link,"0")[0].click
      within ".well" do
        select "Elmer Fudd", from: "membership_user_id"
        select "Owner", from: "membership_title"
      end
      click_on "Add New Member"
      expect(page).to have_content("Elmer Fudd was added successfully.")
      expect(page).to have_content("Elmer Fudd")
      expect(page).to have_content("Owner")
      expect(page).to have_button("Update")
    end

  scenario "Users cannot add the same member to a project twice" do
    visit projects_path
    page.all(:link,"0")[0].click
    select "Elmer Fudd", from: "membership_user_id"
    select "Owner", from: "membership_title"
    click_on "Add New Member"
    select "Elmer Fudd", from: "membership_user_id"
    click_on "Add New Member"
    expect(page).to have_content("User has already been added")
  end

  scenario "Users can be added to multiple projects" do
    project = Project.create!(
      name: "Make River of Cheese"
    )
    visit projects_path
    page.all(:link,"0")[0].click
    select "Elmer Fudd", from: "membership_user_id"
    select "Owner", from: "membership_title"
    click_on "Add New Member"
    expect(page).to have_content("Elmer Fudd was added successfully.")

    visit projects_path
    click_on "Make River of Cheese"
    click_on "0 Members"
    select "Elmer Fudd", from: "membership_user_id"
    select "Member", from: "membership_title"
    click_on "Add New Member"
    expect(page).to have_content("Elmer Fudd was added successfully.")
  end

  scenario "Users see breadcrumbs on the memberships index and project show" do
    visit root_path
    click_on "Projects"
    click_on "Scale Mountain on Pogo Stick"
    page.all(:link,"Projects")[0].click
    expect(page).to have_content("Projects")

    page.all(:link,"0")[0].click
    expect(page).to have_content "Scale Mountain on Pogo Stick: Manage Members"
    click_on "Scale Mountain on Pogo Stick"
    expect(page).to have_content "Scale Mountain on Pogo Stick"
    click_on "0 Members"
    page.all(:link,"Projects")[0].click
    expect(page).to have_content "Name"
    expect(page).to have_content "Members"
    expect(page).to have_content "Tasks"
  end

  scenario "Users can change the role of project members" do
    visit projects_path
    page.all(:link,"0")[0].click
    within '.well' do
      select "Elmer Fudd", from: "membership_user_id"
      select "Member", from: "membership_title"
      click_on "Add New Member"
    end
    within '.table' do
       select "Owner", from: "membership_title"
    end
    click_on "Update"
  end

  scenario "Users can remove project members" do
    visit projects_path
    page.all(:link,"0")[0].click
    select "Elmer Fudd", from: "membership_user_id"
    select "Owner", from: "membership_title"
    click_on "Add New Member"
    find('.glyphicon').click
    expect(page).to have_content "Elmer Fudd was removed successfully."
  end

  end
