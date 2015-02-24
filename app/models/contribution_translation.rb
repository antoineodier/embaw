class ContributionTranslation < ActiveRecord::Base
  belongs_to :translation
  belongs_to :user
  validates :transcription, presence: true
end