class CreateExpenses < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      CREATE TYPE expenses_category AS ENUM (
        'apparel', 'entertainment', 'grocery', 'meal', 'utility', 'misc'
      );
    SQL

    create_table :expenses do |t|
      t.column :category, :expenses_category
      t.decimal :total, precision: 10, scale: 2
      t.datetime :paid_at
      t.string :tags, array: true
      t.references :user, foreign_key: true

      t.timestamps
    end

    add_index :expenses, :tags, using: 'gin'
  end

  def down
    remove_index :expenses, :tags
    drop_table :expenses
    execute "DROP type expenses_category;"
  end
end
