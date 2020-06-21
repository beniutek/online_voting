ActiveAdmin.register Configuration do
  permit_params :name, :data

  json_editor

  index do
    selectable_column
    id_column
    column :name
    column :data
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :data, as: :json
    end
    f.actions
  end

end
