class AddVoters < ActiveRecord::Migration[6.0]
  def change
    create_table :voters do |t|
      t.string :voter_id, null: false
      t.string :public_key
      t.string :signature
      t.string :data
      t.datetime :signed_vote_at

      t.timestamps
    end

    add_index :voters, :voter_id, unique: true
  end
end
