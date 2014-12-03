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
      within "table.table" do
        page.all(:link,"0")[0].click
      end
      expect(page).to have_content "Scale Mountain on Pogo Stick"
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
    project = Project.create!(
      name: "Make River of Cheese"
    )
    page.all(:link,"0")[0].click
    select "Elmer Fudd", from: "membership_user_id"
    select "Owner", from: "membership_title"
    click_on("Add New Member")
    expect(page).to have_content("Elmer Fudd was added successfully.")

    visit projects_path
    click_on("Make River of Cheese")
    click_on("0 Members")
    select "Elmer Fudd", from: "membership_user_id"
    select "Member", from: "membership_title"
    click_on("Add New Member")
    expect(page).to have_content("Elmer Fudd was added successfully.")
  end

  scenario "Users see breadcrumbs on the memberships index and project show" do
    visit root_path
    click_on("Projects")
    click_on("Scale Mountain on Pogo Stick")
    page.all(:link,"Projects")[0].click
    expect(page).to have_content("Projects")

    page.all(:link,"0")[0].click
    expect(page).to have_content "Scale Mountain on Pogo Stick: Manage Members"
    click_on("Scale Mountain on Pogo Stick")
    expect(page).to have_content "Scale Mountain on Pogo Stick"
    click_on("0 Members")
    page.all(:link,"Projects")[0].click
    expect(page).to have_content "Name"
    expect(page).to have_content "Members"
    expect(page).to have_content "Tasks"
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
      select "Owner", from: "membership_title"
    end
    click_on("Add New Member")
    within '.table' do
       select "Member", from: "membership_title"
    end
    click_on("Update")
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
    find('.glyphicon').click
    expect(page).to have_content "Barry Bonds was removed successfully."
  end

  end
