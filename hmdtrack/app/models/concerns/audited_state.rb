module AuditedState
  extend ActiveSupport::Concern

  included do
    after_create :create_new_state

    has_many :hmd_states
  end

  def state=(new_state)
    
    if new_state != "announced" and new_state != "devkit" and new_state != "released"
      raise "Validation Error: #{new_state} is not a valid state"
    else
      @new_hmd_state = self.hmd_states.build( state: new_state )
      @new_hmd_state.save
      @state = @new_hmd_state.state
    end

  end

  def state
    @state
  end

  private

  	def create_new_state
      self.state = "announced"
  	end

end


# module Auditable
#   extend ActiveSupport::Concern

#   included do
#     has_many          :audits, as: :auditable

#     after_create      :record_creation
#     before_destroy    :record_deletion 
#   end

#   def record_creation
#     Audit.record_created(self)
#   end

#   def record_deletion
#     Audit.record_deletion(self)
#   end

# end