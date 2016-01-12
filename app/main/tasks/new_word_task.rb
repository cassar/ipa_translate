class NewWordTask < Volt::Task
  require 'httparty'

  def process_words(sentence)
    @new_word_array = []
    sentence.downcase.split.each do |entry|
      next if store.words.where(entry: entry).first.sync.present?
      @new_word_array << create_word(entry)
    end
    assign_ipa_entries(@new_word_array)
    true
  end

  def create_word(entry)
    store.words.create(entry: entry).sync
  end

  def assign_ipa_entries(word_array)
    word_array.each do |word|
      word.ipa = return_ipa_word(word.entry)
    end
  end

  def return_ipa_word(entry)
    @ipa_entry = retrieve_ipa_word_from_wiktionary(entry)
    if @ipa_entry.present?
      @ipa_entry
    else
      recheck_with_capitalize(entry)
    end
  end

  def recheck_with_capitalize(entry)
    @ipa_entry_caps = retrieve_ipa_word_from_wiktionary(entry.capitalize)
    if @ipa_entry_caps.present?
      @ipa_entry_caps
    else
      '[new]'
    end
  end

  def retrieve_ipa_word_from_wiktionary(entry)
    @word_array = []
    @uri = URI.encode("https://en.wiktionary.org/w/index.php?title=#{entry}&printable=yes".strip)
    @response = HTTParty.get(@uri)
    @slash_scan = @response.scan(%r{(?<=>/)(.*?)(?=/)})
    @word_array << @slash_scan if @slash_scan.present?
    first_array_entry(@word_array)
  end

  def first_array_entry(word_array)
    @numberless_array = []
    word_array.flatten.each do |element|
      @numberless_array << element if (/[0-9]/ =~ element).nil?
    end
    @numberless_array.first.gsub(%r{(\/|\s|\(|\))}, '') if word_array.present?
  end
end
