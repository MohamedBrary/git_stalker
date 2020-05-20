
class Upsert::Release < Mutations::Command
  required do
    string :external_id
    string :tag_name
    string :state
    model :git_update
    model :repository
    model :releaser, class: User
  end

  def execute
    # TODO add external_source too so we can identify unique release
    release = Release.where(
      external_id: external_id,
      releaser_id: releaser.id
    ).first

    if release.present?
      # TODO handle conflicts if record exists, and new changes detected
      release
    else
      Release.create(inputs)
    end
  end

end
