class PushUpdate::Commit < Mutations::Command
  required do
    model :commit
  end

  def execute
    PushUpdate::Send.run(payload: update_params)
  end

  def update_params
    if commit.pushed?
      ready_for_release_params
    elsif commit.released?
      released_params
    end
  end

  def ready_for_release_params
    {
      query: 'state #{ready for release}',
      issues: update_issues,
      comment: "See SHA ##{commit.sha}"
    }
  end

  def released_params
    {
      query: 'state #{released}',
      issues: update_issues,
      comment: "Released in #{commit.release.tag_name || commit.sha}"
    }
  end

  def update_issues
    commit.ticket_ids.map do |ticket_id|
      {id: ticket_id}
    end
  end
end
