class Transcription < ActiveRecord::Base
  has_many :scans
  validates :path_to_xml_file, uniqueness: true, presence: true

  def xml_content
    client = Octokit::Client.new(:access_token => ENV['GITHUB_TOKEN'])
    content = client.contents('antoineodier/egodocuments-transcriptions', path: self.path_to_xml_file).content
    text = Base64.decode64(content)
    return text
  end
end