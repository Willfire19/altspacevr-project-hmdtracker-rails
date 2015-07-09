class Hmd < ActiveRecord::Base
  # TODO: Make this work!
  # include AuditedState
  #
  # has_audited_state_through :hmd_states, [:announced, :devkit, :released]

  after_save :create_new_state

  has_many :hmd_states

  validate :check_state

  def state=(new_state)
    @state = new_state
  end

  def state
    @state
  end

  def check_state
    if @state != "announced" and @state != "dev_kit" and @state != "released"
      errors.add(:base, "#{@state} is not a valid state")
      return false
    else
      return true
    end
  end

  private

  	def create_new_state
  		@new_hmd_state = self.hmd_states.build( state: state )
  		@new_hmd_state.save
  	end

end
