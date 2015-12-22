require 'spec_helper'

describe NewWordTask, type: :task do
  it 'should create a new word when passed an entry' do
    NewWordTask.new_word('hello')

    expect(store.words.count.sync).to eq(1)
  end
end
