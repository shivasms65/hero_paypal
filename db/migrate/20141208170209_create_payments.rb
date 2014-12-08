class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :user_id
      t.string :token
      t.string :profile_id
      t.timestamps
    end
  end
end
