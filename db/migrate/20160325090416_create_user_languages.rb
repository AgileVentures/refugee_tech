class CreateUserLanguages < ActiveRecord::Migration
  def change
    create_table :user_languages do |t|
      t.string :level
      t.boolean :spoken, default: false
      t.boolean :written,default: false 
      t.belongs_to :user, index: true
      t.belongs_to :language, index: true
      t.timestamps null: false
    end
  end
end
