class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :transaction_type, null: false
      t.decimal :amount_usd, precision: 15, scale: 2, null: false
      t.decimal :amount_btc, precision: 15, scale: 8, null: false

      t.timestamps
    end
  end
end
