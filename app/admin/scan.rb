ActiveAdmin.register Scan do
  permit_params :picture, :transcription_id

  form do |f|
    f.inputs "Ajouter un scan" do
      f.input :picture, :as => :file, :hint => f.template.image_tag(f.object.picture.url(:thumb))
      # Will preview the image when the object is edited
      input :transcription
    end

    f.actions
  end

  show do |ad|
    attributes_table do
      row :picture do
        image_tag(ad.picture.url(:thumb))
      end
      # Will display the image on show object page
    end
  end
end
