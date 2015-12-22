require 'spec_helper'

describe NewWordTask, type: :task do
  it 'should create a new word when passed an entry' do
    NewWordTask.process_words('hello my name is')

    expect(store.words.count.sync).to eq(4)
  end
end
