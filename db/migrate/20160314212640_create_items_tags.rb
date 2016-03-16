class CreateItemsTags < ActiveRecord::Migration
  def change
    create_table :items_tags, :id => false do |t|
      t.references :item
      t.references :tag
      t.timestamps
    end
  end
end
