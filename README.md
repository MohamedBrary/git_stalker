## Creating Rails Project

Based on https://gist.github.com/MohamedBrary/12465abb009d5dbeadeb8cde9adb30b5

### Initialization

```sh
# List available rubies, to choose which ruby to use
$ rvm list rubies

# To install new ruby use, for example version '2.7.1'
$ rvm install 2.7.1

# create and use the new RVM gemset for project "git_stalker"
$ rvm use --create 2.7.1@my_git_stalker

# install latest rails into the blank gemset
$ gem install rails -v 6.0.3

# Creates new rails app "git_stalker"
# -d mysql: defining database (other options: mysql, oracle, postgresql, sqlite3, frontbase)
# -T to skip generating test folder and files (in case of planning to use rspec)
# --api to create an API only application
$ rails new git_stalker -d postgresql -T --api

# go into the new project directory and create a .ruby-version and .ruby-gemset for the project
$ cd git_stalker
$ rvm --ruby-version use 2.7.1@git_stalker

# initialize git
$ git init
$ git add .
$ git commit -m 'CHORE: initial commit with new rails api app and initial gems'
$ git remote add origin git@github.com:MohamedBrary/git_stalker.git
$ git push -u origin master
```

### Generating Models

```sh
# generate models
# duplicate ids in different models to prevent later joins when we need the stats
rails g model User name email external_id external_source
rails g model Repository name external_id external_source
rails g model GitUpdate user:references repository:references event external_source payload:json
rails g model Release git_update:references repository:references releaser:references ticket_ids external_id released_at:timestamp tag_name state # state would be updated through PullRequest updates
rails g model Commit git_update:references repository:references release:references committer:references pusher:references pushed_at:timestamp pull_request_ids ticket_ids sha message state
rails g model PullRequest git_update_ids repository:references creator:references approver:references closer:references external_id ticket_ids state
# rails g model Ticket code title project_id # now it is just a code in other models
```

### Future Thoughts

1. When changing the version control or the task manager, we would need to:
   - upgrade the external_source field to a full model, so it would handle also the payload translation from its signature, to our internal modeling setup, and we wouldn't have to change a lot in our code, just add new 'translations' logic per each internal model we have (commit, pull request, ... etc).
  - also we would need to upgrade the Committer, into User that has many ExternalUser records, so we would link our same committers between different services (through email for example)

2. If we need to upgrade the system to handle more events and stats, we would need to:
   - store more data that are available, and upgrade some models
   - for example instead of storing extra un-wanted stuff now in pay_load of GitRequest records, they would have their own field in the model, or even new model, based on the requirements
   - add more indexes based on the stats needed
