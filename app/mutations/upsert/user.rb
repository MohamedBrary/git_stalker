
class Upsert::User < Mutations::Command
  required do
    string :name
    string :email
    string :external_id
    string :external_source
  end

  def execute
    user = User.where(email: email).first
    if user.present?
      # TODO handle conflicts if record exists, and new changes detected
      user
    else
      User.create(inputs)
    end
  end
end
