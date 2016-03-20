class RemoveStreetFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :street, :string
  end
end
