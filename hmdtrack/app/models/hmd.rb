class Hmd < ActiveRecord::Base
  # TODO: Make this work!
  # include AuditedState
  #
  # has_audited_state_through :hmd_states, [:announced, :devkit, :released]

  # after_initialize :assign_state_default, if: 'new_record?'
  # after_save :create_new_state

  has_many :hmd_states

  validates :state, presence: true

  # validate :check_state

  def state=(new_state)

    if new_state != "announced" and new_state != "devkit" and new_state != "released"
      raise "#{new_state} is not a valid state"
    else
      @new_hmd_state = self.hmd_states.build( state: new_state )
      @new_hmd_state.save
      @state = @new_hmd_state.state
    end
    # @previous_state = state
    # @state = new_state
  end

  def state
    @state
  end

  # def previous_state=(old_state)
  #   @previous_state = old_state
  # end

  # def previous_state
  #   @previous_state
  # end

  # def check_state
  #   if @state != "announced" and @state != "devkit" and @state != "released"
  #     errors.add(:base, "#{@state} is not a valid state")
  #     @state = previous_state
  #     return false
  #   else
  #     return true
  #   end
  # end

  private

  	# def create_new_state
  	# 	@new_hmd_state = self.hmd_states.build( state: state )
  	# 	@new_hmd_state.save
  	# end

    # def assign_state_default
    #   # @state = "announced"
    #   self.state = "announced"
    # end

end
