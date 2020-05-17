class CreateVote < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.integer :rank
      t.string :bit_commitment
      t.string :signed_message
    end
  end
end
