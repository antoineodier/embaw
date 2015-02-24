class CreateTranscriptions < ActiveRecord::Migration
  def change
    create_table :transcriptions do |t|
      t.string :path_to_xml_file

      t.timestamps null: false
    end
  end
end
