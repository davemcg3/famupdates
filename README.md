# famupdates

Rails 6 app that allows users to follow each other and see the latest status from everyone they are following in one easy-to-use screen. Also supports a "wall" for each user that users can post on. Supports blocking other users as well.

### Ruby version
3.0.2
Check Gemfile if this seems out-of-date.

### Rails version
6.1.4.1
Check Gemfile if this seems out-of-date.

### System dependencies
Using Puma for the web server

Using devise for authentication

Using SendGrid for administrative emails

Authorization handled by Pundit

### Configuration
To run locally do the setup:

`rvm use 3.0.2`

`bundle`

* First run:

`rails db:setup`

* Later runs:

`rails db:migrate`

Then:

`rails s`

### How to run the test suite (e.g. "run specs")
`rspec spec`

### Services (job queues, cache servers, search engines, etc.)
Puma is currently setup to support workers. Have not added sidekiq or redis to handle asynchronous tasks as there are none to run currently. 

### Deployment instructions
#### Setup the release

Create a new release branch:

`git checkout -b release/vX.X.X-xxxx`

Merge your feature branch to the release branch. 

#### Test the release
Pull the release branch down locally. Run specs. Run the server locally and click around making sure you can register, login, create a new status, create a new wall post, logout. 

#### Deploy the release
Open a pull request from the release branch to main. Merging to main will autodeploy to Heroku through Heroku pipelines. There is no CI/CD currently so when you are ready to deploy just merge.

There is protection on the main branch requiring review from code owners before merge.

Close the issue you're resolving. If the ticket is not automatically moved to "Done" in the Brightbane project then move it manually.

#### Tag the release
Update your main branch to get the merge commit

`git checkout main`

`git pull`

Set the HEAD to the old commit that we want to tag where xxxxxxx is the commit hash

`git checkout xxxxxxx`

temporarily set the date to the date of the HEAD commit, and add the tag
Ex: v0.0.1-alpha

`GIT_COMMITTER_DATE="$(git show --format=%aD | head -1)" \ `

`git tag -a vX.X.X-xxxx -m"vX.X.X-xxxx"`

Set HEAD back to whatever you want it to be

`git checkout main`

Push changes to the repo

`git push origin --tags`
