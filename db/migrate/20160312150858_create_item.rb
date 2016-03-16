class CreateItem < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.references :list
      t.timestamps
    end
  end
end
