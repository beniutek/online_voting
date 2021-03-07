ActiveAdmin.register Result do
  json_editor

  index do
    selectable_column
    id_column
    column :result
    actions
  end

  show do
    attributes_table do
      row :result do |model|
        model.result
      end
    end
  end
end
