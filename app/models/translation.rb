class Translation < ActiveRecord::Base
  belongs_to :transcription
  validates :path_to_xml_file, presence: true
  validates :transcription, presence: true
end
