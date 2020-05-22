class CreateCandidates < ActiveRecord::Migration[6.0]
  def change
    create_table :candidates do |t|
      t.uuid :uuid
      t.string :description
      t.timestamps
    end
  end
end
