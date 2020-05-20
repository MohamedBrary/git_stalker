Rails.application.routes.draw do
  post 'git_updates' => 'git_updates#create'
end
