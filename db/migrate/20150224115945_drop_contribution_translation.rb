class DropContributionTranslation < ActiveRecord::Migration
  def change
    drop_table :contribution_translations
  end
end
