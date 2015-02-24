class AddTranscriptionToTranslations < ActiveRecord::Migration
  def change
    add_reference :translations, :transcription, index: true
    add_foreign_key :translations, :transcriptions
  end
end
