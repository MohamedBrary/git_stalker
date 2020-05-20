class GitUpdatesController < ApplicationController

  # POST /git_updates
  def create
    @git_update = GitUpdate.new(git_update_params)

    if @git_update.save
      render json: @git_update, status: :created, location: @git_update
    else
      render json: @git_update.errors, status: :unprocessable_entity
    end
  end

  private
    # Only allow a trusted parameter "white list" through.
    def git_update_params
      @git_update_params ||= ProcessPayload::GitUpdate.run(params.permit!).result
    end
end
