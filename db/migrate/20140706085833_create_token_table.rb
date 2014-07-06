class CreateTokenTable < ActiveRecord::Migration
  def change
    create_table :user_tokens do |t|
      t.belongs_to :user
      t.string :token_type
      t.string :token
      t.datetime :expires_after
      t.timestamps
    end
  end
end
