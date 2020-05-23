class AddDefaultValToUuidInCandidates < ActiveRecord::Migration[6.0]
  def change
    enable_extension "pgcrypto" unless extension_enabled?("pgcrypto")

    change_column :candidates, :uuid, :uuid, default: 'gen_random_uuid()', null: false
    change_column :votes, :uuid, :uuid, default: 'gen_random_uuid()', null: false
  end
end
