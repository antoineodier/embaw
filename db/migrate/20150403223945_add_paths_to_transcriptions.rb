class AddPathsToTranscriptions < ActiveRecord::Migration
  def change
    add_column :transcriptions, :path_to_diplomatic_transcription, :string
    add_column :transcriptions, :path_to_normalized_transcription, :string
    add_column :transcriptions, :path_to_diplomatic_transformation, :string
    add_column :transcriptions, :path_to_normalized_transformation, :string
  end
end
