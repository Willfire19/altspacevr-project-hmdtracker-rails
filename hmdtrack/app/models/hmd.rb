class Hmd < ActiveRecord::Base
  # TODO: Make this work!
  include AuditedState
  #
  # has_audited_state_through :hmd_states, [:announced, :devkit, :released]

  # after_create :create_new_state

  # has_many :hmd_states

  # def state=(new_state)
    
  #   if new_state != "announced" and new_state != "devkit" and new_state != "released"
  #     raise "Validation Error: #{new_state} is not a valid state"
  #   else
  #     @new_hmd_state = self.hmd_states.build( state: new_state )
  #     @new_hmd_state.save
  #     @state = @new_hmd_state.state
  #   end

  # end

  # def state
  #   @state
  # end

  # private

  # 	def create_new_state
  #     self.state = "announced"
  # 	end

end
