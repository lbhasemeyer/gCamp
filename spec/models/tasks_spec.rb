require 'rails_helper'

describe Task do

  it 'verifies entry of all fields' do
    task = Task.new
    expect(task.valid?).to be(false)
    task.description = 'Eat Cheetos'
    expect(task.valid?).to be(false)
    task.due_date = '12/12/2014'
    expect(task.valid?).to be(true)
  end

end
