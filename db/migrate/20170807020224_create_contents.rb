class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.belongs_to :article, index: true
      t.text :display_text

      t.timestamps null: false
    end
  end
end
