class CreateVote < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.uuid :uuid
      t.string :bit_commitment
      t.string :signed_message
      t.jsonb :decoded
      t.timestamps
    end
  end
end
