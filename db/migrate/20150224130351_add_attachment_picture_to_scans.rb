class AddAttachmentPictureToScans < ActiveRecord::Migration
  def self.up
    change_table :scans do |t|
      t.attachment :picture
    end
  end

  def self.down
    remove_attachment :scans, :picture
  end
end
