class Translation < ActiveRecord::Base
  belongs_to :transcription
  has_many :users, through: :contribution_translations
  validates :path_to_xml_file, presence: true
  validates :transcription, presence: true
end
