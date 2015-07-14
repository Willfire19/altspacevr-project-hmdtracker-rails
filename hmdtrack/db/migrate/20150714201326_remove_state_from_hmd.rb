class RemoveStateFromHmd < ActiveRecord::Migration
  def change
  	Hmd.find_each do |hmd|
  		HmdState.create(hmd_id: hmd.id, state: hmd.state, created_at: hmd.announced_at)
		end
    
    remove_column :hmds, :state, :string
  end
end
