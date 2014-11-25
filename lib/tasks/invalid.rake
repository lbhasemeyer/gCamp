namespace :invalid do
  desc "delete invalid memberships"
  task memberships: :environment do
    Membership.where.not(user_id: User.pluck(:id)).delete_all
    Membership.where.not(project_id: Project.pluck(:id)).delete_all
  end

  desc "delete invalid comments"
  task comments: :environment do
    Comment.where.not(task_id: Task.pluck(:id)).delete_all
    Comment.where.not(user_id: User.pluck(:id)).delete_all
  end
end
