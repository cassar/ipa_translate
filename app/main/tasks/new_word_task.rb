class NewWordTask < Volt::Task
  def process_words(sentence)
    sentence.downcase.split.each do |entry|
      next if store.words.where(entry: entry).first.sync.present?
      store.words.create(entry: entry, ipa: '[new]').sync
    end
  end
end
