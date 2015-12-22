class NewWordTask < Volt::Task
  def new_word(entry)
    store.words.create(entry: entry, ipa: '[new]').sync
  end
end
