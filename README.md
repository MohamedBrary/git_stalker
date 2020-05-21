
## Creating GitStalker Rails Project
### Table of Contents
  * [Initialization](#initialization)
  * [Generating Models](#generating-models)
  * [Main Logic Components](#main-logic-components)
    + [ProcessPayload](#processpayload)
    + [Upsert](#upsert)
    + [PushUpdate](#pushupdate)
  * [API Suite](#api-suite)
  * [Test Suite](#test-suite)
  * [Future Thoughts](#future-thoughts)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

### Initialization
Based on this [gist](https://gist.github.com/MohamedBrary/12465abb009d5dbeadeb8cde9adb30b5) .
```sh
# List available rubies, to choose which ruby to use
$ rvm list rubies

# To install new ruby use, for example version '2.7.1'
$ rvm install 2.7.1

# create and use the new RVM gemset for project "git_stalker"
$ rvm use --create 2.7.1@git_stalker

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

![GitStalker ERD](https://github.com/MohamedBrary/git_stalker/blob/master/erd.jpg?raw=true)


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

### Main Logic Components

I used 'mutations' [gem](https://github.com/cypriss/mutations) to encapsulate logic in separate services, and try to decouple 3rd party from our core app, this would also allow for extending the application without much of changes, this is achieved by implementing three groups of services:

#### ProcessPayload
These services takes the 3rd party payload as their representation of a resource, and do the transformation to our internal representation of the corresponding model. So changing the 3rd part service, or supporting different ones, would require changes only in this layer.

#### Upsert
These services takes the output of ProcessPayload, which is an ActiveRecord friendly hash, and handles the persistence of the information. Whether to create new records, or update existing ones, and also takes care of establishing the relations between different resources.

#### PushUpdate
These services pushes the updates we observe in our resources to an external 3rd party. (you can see the test pushes in this [link](https://webhook.site/#!/1a8aef30-f76d-45f9-8169-7c09d65eccce/3d0b808d-830a-47d1-be6d-4f646528313f/1))


### API Suite

I used 'rspec_api_documentation' [gem](https://github.com/zipmark/rspec_api_documentation), which is very nice, it makes you follow TDD for your API, so you write down the API request signature, add your tests, and at the same time it takes these info and generate a nice looking API documentation (found at doc/api/index.html that can be exposed as a public route)

### Test Suite

I used the given payload example jsons, as test fixtures, and as seeds for the database. (also used them to dyncamiacally generate API documentation)
The current simple tests, make sure that application would process the different payloads and create the correct number of records. Also it tests handling the duplicate requests, and makes sure that we don't create duplicate records.

### Future Thoughts

1. This implementation lacks a lot of error validations, and more in-depth tests in order for it to be fully functional, and maybe deploying to heroku also
2. When changing the version control or the task manager, we would need to:
   - upgrade the external_source field to a full model, so it would handle also the payload translation from its signature, to our internal modeling setup, and we wouldn't have to change a lot in our code, just add new group of ProcessPayload services per each internal model we have (commit, pull request, ... etc).
   - also we would need to upgrade the User to have many ExternalUser records, so we would link our same committers between different services (through email for example)

3. If we need to upgrade the system to handle more events and stats, we would need to:
   - store more data that are available, and upgrade some models
   - for example instead of storing extra unwanted stuff now in payload of GitUpdate records, they would have their own field in the model, or even new model, based on the requirements
   - add more indexes based on the stats needed
   - storing the original payload in GitUpdate model allows us to support any data modeling changes for existing records as well
