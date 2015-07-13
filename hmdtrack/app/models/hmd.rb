class Hmd < ActiveRecord::Base
  # TODO: Make this work!
  include AuditedState
  #
  # has_audited_state_through :hmd_states, [:announced, :devkit, :released]

end
