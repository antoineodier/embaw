class CreateContributionTranslations < ActiveRecord::Migration
  def change
    create_table :contribution_translations do |t|
      t.references :translation, index: true
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :contribution_translations, :translations
    add_foreign_key :contribution_translations, :users
  end
end
