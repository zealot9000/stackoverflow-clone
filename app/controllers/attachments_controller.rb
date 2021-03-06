class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  respond_to :js

  authorize_resource

  def destroy
    @attachment = Attachment.find(params[:id])
    @attachment.destroy if current_user.author?(@attachment.attachable)
    respond_with(@attachment)
  end
end
