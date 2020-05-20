class GitUpdatesController < ApplicationController

  # POST /git_updates
  def create
    outcome = Upsert::GitUpdate.run(git_update_params)

    if outcome.success?
      @git_update = outcome.result
      render json: @git_update, status: :ok
    else
      render json: outcome.errors, status: :unprocessable_entity
    end
  end

  private
    # Only allow a trusted parameter "white list" through.
    def git_update_params
      @git_update_params ||= ProcessPayload::GitUpdate.run(params.permit!).result
    end
end
