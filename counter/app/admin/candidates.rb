ActiveAdmin.register Candidate do
  permit_params :description, :uuid

  index do
    selectable_column
    id_column
    column :description
    column :uuid
    actions
  end

  form do |f|
    f.inputs do
      f.input :description
    end
    f.actions
  end

end
