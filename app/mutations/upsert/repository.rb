
class Upsert::Repository < Mutations::Command
  required do
    string :name
    string :external_id
    string :external_source
  end

  def execute
    repository = Repository.where(
      external_id: external_id,
      external_source: external_source
    ).first

    if repository.present?
      # TODO handle conflicts if record exists, and new changes detected
      repository
    else
      Repository.create(inputs)
    end
  end
end
