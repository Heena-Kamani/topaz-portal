class CreateQuotes < ActiveRecord::Migration[8.1]
  def change
    create_table :quotes do |t|
      t.references :client, null: false, foreign_key: true
      t.string :title, null: false
      t.string :status, null: false, default: "draft"
      t.string :share_token
      # Tax in basis points: 500 = 5% (Alberta only charges GST)
      t.integer :tax_rate_bps, null: false, default: 500
      t.datetime :accepted_at
      t.string :accepted_by_name
      t.integer :accepted_total_cents

      t.timestamps
    end
    add_index :quotes, :share_token, unique: true
  end
end
