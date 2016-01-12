require 'spec_helper'

describe NewWordTask, type: :task do
  it 'should create new words when passed a sentence string' do
    NewWordTask.process_words('hello my name is')

    expect(store.words.count.sync).to eq(4)
  end

  it 'should create a new word and IPA' do
    @word = NewWordTask.create_word('hello').sync

    expect(store.words.count.sync).to eq(1)
    expect(@word.entry).to eq('hello')

    @array = []
    @array << @word
    NewWordTask.assign_ipa_entries(@array).sync

    expect(@word.ipa).to eq('həˈləʊ̯')
  end

  it 'should return an ipa word' do
    @ipa_word = NewWordTask.return_ipa_word('hello').sync

    expect(@ipa_word).to eq('həˈləʊ̯')
  end

  it 'should return a placeholder' do
    @placeholder = NewWordTask.return_ipa_word('woodchuck').sync

    expect(@placeholder).to eq('[new]')
  end

  it 'should recheck an entry with capitalize' do
    @proper_noun = NewWordTask.recheck_with_capitalize('rome').sync

    expect(@proper_noun).to eq('rəʊm')
  end

  it 'should retrieve_ipa_word_from_wiktionary' do
    @ipa_word = NewWordTask.retrieve_ipa_word_from_wiktionary('hello').sync

    expect(@ipa_word).to eq('həˈləʊ̯')
  end

  it 'should return the first numberless array entry' do
    @entry = NewWordTask.first_array_entry(%w(Hello5 http9 hello)).sync

    expect(@entry).to eq('hello')
  end
end
