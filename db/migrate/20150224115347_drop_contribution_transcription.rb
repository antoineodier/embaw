class DropContributionTranscription < ActiveRecord::Migration

  def change
    drop_table :contribution_transcriptions
  end

end
