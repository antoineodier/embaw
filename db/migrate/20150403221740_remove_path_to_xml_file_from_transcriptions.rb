class RemovePathToXmlFileFromTranscriptions < ActiveRecord::Migration
  def change
    remove_column :transcriptions, :path_to_xml_file, :string
  end
end
