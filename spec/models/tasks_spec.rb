require 'rails_helper'

describe Task do

  it 'verifies entry of all fields' do
    task = Task.new
    expect(task.valid?).to be(false)
    task.description = 'Eat Cheetos'
    expect(task.valid?).to be(true)
  end

  it 'verifies date is today or after' do
    task = Task.new
    task.description = 'Eat Cheetos'
    task.due_date = '10/12/2001'
    expect(task.valid?).to be(false)
    task.due_date = '12/12/3024'
    expect(task.valid?).to be(true)
  end

  include ActiveSupport::Testing::TimeHelpers

  it 'verifies users can update a task whose due date is in the past' do
    travel_to 1.year.ago do
      task = Task.new(
        :description => 'Eat Cheetos',
        :due_date => Date.today,
        )
    end
    expect(task.valid?).to be(true)
    task.due_date = '10/12/2001'
    expect(task.valid?).to be(true)
    task.due_date = '10/12/3001'
    expect(task.valid?).to be(true)
  end


end
