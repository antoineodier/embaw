class Transcription < ActiveRecord::Base
  has_many :scans
  validates :path_to_xml_file, uniqueness: true, presence: true
end