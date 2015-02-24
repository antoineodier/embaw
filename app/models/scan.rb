class Scan < ActiveRecord::Base
  belongs_to :transcription
  validates :transcription, presence: true
end
