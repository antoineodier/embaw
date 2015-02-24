class Transcription < ActiveRecord::Base
  has_many :scans
  has_many :users, through: :contribution_transcriptions
  validates :path_to_xml_file, uniqueness: true, presence: true
end
