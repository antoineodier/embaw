class CreateContributionTranscriptions < ActiveRecord::Migration
  def change
    create_table :contribution_transcriptions do |t|
      t.references :transcription, index: true
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :contribution_transcriptions, :transcriptions
    add_foreign_key :contribution_transcriptions, :users
  end
end
