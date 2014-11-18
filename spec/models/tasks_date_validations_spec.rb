require 'rails_helper'

describe Task do

  it 'verifies entry of all fields' do
    task = Task.new
    task.valid?
    expect(task.errors.present?).to eq(true)
    task.description = 'Eat Cheetos'
    task.valid?
    expect(task.errors.present?).to eq(false)
    end

  it 'verifies date is today or after' do
    task = Task.new
    task.description = 'Eat Cheetos'
    task.due_date = '10/12/2001'
    task.valid?
    expect(task.errors.present?).to eq(true)
    task.due_date = '12/12/3024'
    task.valid?
    expect(task.errors.present?).to eq(false)
  end

  include ActiveSupport::Testing::TimeHelpers
  it 'verifies users can update a task whose due date is in the past' do
    task=Task.new
    travel_to 1.year.ago do
        task.description= 'Eat Cheetos'
        task.due_date= Date.today
        task.valid?
        expect(task.errors.present?).to eq(false)
        expect(task.valid?).to be(true)
        task.save
    end
    task.valid?
    expect(task.errors.present?).to eq(false)
    task.due_date = '10/12/2001'
    task.valid?
    expect(task.errors.present?).to eq(false)
    task.due_date = '10/12/3001'
    task.valid?
    expect(task.errors.present?).to eq(false)
    task.description = 'Find Pig'
    task.valid?
    expect(task.errors.present?).to eq(false)
    task.complete = "true"
    task.valid?
    expect(task.errors.present?).to eq(false)
  end

end
