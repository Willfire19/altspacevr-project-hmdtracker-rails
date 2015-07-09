class RemoveStateFromHmd < ActiveRecord::Migration
  def change
    remove_column :hmds, :state, :string
  end
end
