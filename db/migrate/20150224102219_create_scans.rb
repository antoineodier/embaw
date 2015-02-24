class CreateScans < ActiveRecord::Migration
  def change
    create_table :scans do |t|
      t.references :transcription, index: true

      t.timestamps null: false
    end
    add_foreign_key :scans, :transcriptions
  end
end
