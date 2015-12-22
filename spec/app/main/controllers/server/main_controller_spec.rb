require 'spec_helper'

describe Main::MainController do
  before do
    @main_controller = Main::MainController.new(volt_app)
    store.words.create(entry: 'hello', ipa: 'həˈləʊ').sync
    store.words.create(entry: 'you', ipa: 'juː').sync
  end

  it 'should create words that are missing' do
    store._sentence = 'Hello you there'
    @main_controller.search_words

    expect(store.words.count.sync).to eq(3)
  end
end
