class HmdState < ActiveRecord::Base
  # TODO: Make this work!
  # include AuditedState
  # 
  # is_audited_state_for :hmd

  belongs_to :hmd

end
