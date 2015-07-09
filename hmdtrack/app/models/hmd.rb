class Hmd < ActiveRecord::Base
  # TODO: Make this work!
  # include AuditedState
  #
  # has_audited_state_through :hmd_states, [:announced, :devkit, :released]

  before_save :create_new_state

  has_many :hmd_states

  private

  	def create_new_state
  		@new_hmd_state = self.hmd_states.build( state: "announced" )
  		@new_hmd_state.save
  	end

end
