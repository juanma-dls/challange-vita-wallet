class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email
      t.decimal :balance_usd, precision: 15, scale: 2, default: 0.00, null: false
      t.decimal :balance_btc, precision: 15, scale: 8, default: 0.00000000, null: false

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
