require 'rails_helper'

  feature "memberships" do
    scenario "" do
      project = Project.create!(
        name: "Scale Mountain on Pogo Stick"
        )
      visit projects_path
      page.all(:link,"0")[1].click


    end
  end
