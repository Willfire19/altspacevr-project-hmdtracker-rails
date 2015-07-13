class HmdsController < ApplicationController
  def index
    @hmds = Hmd.all.order("announced_at desc, name desc")
  end

  def edit
    @hmd = Hmd.find(params[:id])
    # @hmds = Hmd.all.order("announced_at desc, name desc")
  end

  def update
    @hmd = Hmd.find(params[:id])
    @hmd.state = params[:hmd][:state]
    @hmd.save!

    redirect_to hmds_path
  end
end
