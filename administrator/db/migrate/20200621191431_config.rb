class Config < ActiveRecord::Migration[6.0]
  def change
    create_table :configurations do |t|
      t.string :name
      t.jsonb :data
      t.timestamps
    end
  end
end
