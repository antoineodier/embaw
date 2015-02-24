class ContributionTranscription < ActiveRecord::Base
  belongs_to :transcription
  belongs_to :user
end
