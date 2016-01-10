class Word < Volt::Model
  field :entry, String
  field :ipa, String

  validate :entry, unique: true
end
