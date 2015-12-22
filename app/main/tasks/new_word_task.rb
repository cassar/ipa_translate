class NewWordTask < Volt::Task
  require 'httparty'

  def process_words(sentence)
    sentence.downcase.split.each do |entry|
      next if store.words.where(entry: entry).first.sync.present?
      create_word(entry)
    end
  end

  def create_word(entry)
    store.words.create(
      entry: entry,
      ipa: return_ipa_word(entry)
    ).sync
  end

  def return_ipa_word(entry)
    @ipa_entry = retrieve_ipa_word_from_wiktionary(entry)
    if @ipa_entry.present?
      @ipa_entry
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
    @numberless_array.first.gsub(%r{(\/|\s)}, '') if word_array.present?
  end
end
