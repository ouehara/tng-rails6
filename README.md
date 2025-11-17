# tsunagu japan

current [staging](http://staging.efm8vxr3aq.ap-northeast-1.elasticbeanstalk.com/)

## System overview

| item                         | description                      |
| ---------------------------- | -------------------------------- |
| Framework                    | Ruby on Rails 5.0.7.2            |
| Ruby Version                 | 2.6.5                            |
| Front end package management | bower bower-rails with Bowerfile |
| Database                     | PostgreSQL                       |
| Issue management             | Github                           |
| Project management           | basic issue management           |
| Infrastructure               | AWS ElasticBeanstalk             |

## Setting up database

Create tsunagu_japan_dev and tsunagu_japan_test database. And set up tsunagu role.

```bash

brew install postgres

$ psql postgres
postgres=# create role tsunagu login createdb;
postgres=# create database tsunagu_japan_dev owner tsunagu;
CREATE DATABASE

$ psql tsunagu_japan_dev
tsunagu_japan_dev=# alter role tsunagu with Superuser;
tsunagu_japan_dev=# alter role tsunagu LOGIN;
tsunagu_japan_dev=# \du
                                   List of roles
 Role name |                         Attributes                         | Member of
-----------+------------------------------------------------------------+-----------
 root      |                                                            | {}
 shiro     | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
 tsunagu   | Superuser                                                  | {}

# Install PGroonga for full text search

 $ brew install pgroonga

```

## Running software

```bash
# RAILS_ENV=development

# Clone
git clone git@github.com:chan-shiro/tsunagu_japan.git
cd tsunagu_japan

# Install ruby version
rbenv install

# Install gem
bundle install

# Set up DB
bundle exec rake db:create
bundle exec rake db:migrate

# Install bower components => Optional
# but bower_components are included in this repository, this is not necessary
bundle exec rake bower:install
bundle exec rake bower:resolve

# Running server
bundle exec rails server -b0.0.0.0
```

then visit `localhost:3000/admin/`, which shows administrators view mock.

## Managing front end packages

### Manage with Bower-rails

All Bower components are located under `vendor/assets/bower_components`.
If you want to use some packages which not provided with Bower, locate them to `vendor/packages/`.

> #### Bowerfile
>
> DSL for bower-rails. We do not love DSL so much, but Bowerfile is very simple and
> provides us usefull commands.

### How to add a package.

1. Edit `vim Bowerfile`. For example, `+asset 'font-awesome', "fontawesome#^4.6.1"`
2. Install bower packages, `bundle exec rake bower:install`
3. Resolve relative path of components, `bundle exec rake bower:resolve`
4. Add require to `app/assets/javascripts/application.coffee`
5. Add `@import` to `app/assets/stylesheets/application.scss`

## Test Driven development with RSpec

Writing...

## Issue management flow

Basic flow is described below. However, you don't have to think this as very strict.
This workflow is flexible and sometimes other approach would be taken.

### Creating an Issue

1. Submit issue
2. Discussion about issue and define specs
3. Estimate workloads
4. Assign member
5. Start development

### Develop and fix issue

1. Create new branch for the Issue (eg. feature/user-sign-in#1)
2. Write test code (optional but highly recommended)
3. Implement code
4. Testing
5. Send Pull Request to master branch with comment (eg. add user sign in feature. this fixes \#1.)
6. Code review and merge PR

## ElasticBeanstalk Configuration

Production: tng-live-1
Staging: tsunagu-staging

### aws cli

Install aws cli

1. pip
2. Homebrew

#### Install with pip

```bash
$ pip install awsebcli

// upgrading
$ pip install --upgrade awsebcli

// when some erros occured
$ pip uninstall awsebcli
$ pip install awsebcli
```

#### Install with Homebrew

```bash
$ brew install awsebcli
```

#### Check

```bash
$ eb --version
EB CLI 3.7.3 (Python 2.7.1)
```

### ElasticBeanstalk Configuration

#### Create new profile with Tsunagu

```bash
$ aws configure --profile tsunagu
AWS Access Key ID [None]: [AccessKeyID]
AWS Secret Access Key [None]: [SecretAccessKey]
Default region name [None]: ap-northeast-1 // Tokyo
Default output format [None]: // optional

// Check
$ cat .aws/credentials
Shiros-MacBook-Pro:~ shiro$ cat .aws/credentials
[default]
aws_access_key_id = [FILTERED]
aws_secret_access_key = [FILTERED]
[tsunagu]
aws_access_key_id = [FILTERED]
aws_secret_access_key = [FILTERED]
```

#### ElasticBeanstalk initialization

With `tsunagu` profile,

```bash

$ eb init --profile tsunagu

Select a default region
1) us-east-1 : US East (N. Virginia)
2) us-west-1 : US West (N. California)
3) us-west-2 : US West (Oregon)
4) eu-west-1 : EU (Ireland)
5) eu-central-1 : EU (Frankfurt)
6) ap-south-1 : Asia Pacific (Mumbai)
7) ap-southeast-1 : Asia Pacific (Singapore)
8) ap-southeast-2 : Asia Pacific (Sydney)
9) ap-northeast-1 : Asia Pacific (Tokyo)
10) ap-northeast-2 : Asia Pacific (Seoul)
11) sa-east-1 : South America (Sao Paulo)
12) cn-north-1 : China (Beijing)
(default is 3): 9

Select an application to use
1) Tsunagu Japan
2) [ Create new Application ]
(default is 2): 1

It appears you are using Ruby. Is this correct?
(y/n): y

Select a platform version.
1) Ruby 2.3 (Puma)
2) Ruby 2.2 (Puma)
3) Ruby 2.1 (Puma)
4) Ruby 2.0 (Puma)
5) Ruby 2.3 (Passenger Standalone)
6) Ruby 2.2 (Passenger Standalone)
7) Ruby 2.1 (Passenger Standalone)
8) Ruby 2.0 (Passenger Standalone)
9) Ruby 1.9.3
(default is 1): 1
Do you want to set up SSH for your instances?
(y/n): y

Select a keypair.
1) tsunagujapan
2) [ Create new KeyPair ]
(default is 3): 1

```

Finished all configuration.

> TODO : Create new key pair tsunagujapan

#### ElasticBeanstalk check configuration

Open `.elasticbeanstalk/config.yml`

```yml
branch-defaults:
  master:
    environment: tng-live-2
environment-defaults:
  tsunagu-staging:
    branch: null
    repository: null
global:
  application_name: tsunagu_japan
  default_ec2_keyname: tng
  default_platform: Puma with Ruby 2.6 running on 64bit Amazon Linux
  default_region: ap-northeast-1
  include_git_submodules: true
  instance_profile: null
  platform_name: null
  platform_version: null
  profile: tsunagu
  sc: git
  workspace_type: Application
```

`branch-defaults` sets which branch to which environment.
In this case, `master` branch will be deployed to `TsunaguJapan-Production` environment

### Deploy to ElasticBeanstalk

Deploy `master` branch to `TsunaguJapan-Staging` environment.

```bash
$ eb deploy
```

### ElasticBeanstalk Environment variables

Set secret configurations as system environment variables.

```bash
$ eb printenv
Environment Variables:
     #  Rails
     RAILS_ENV = production
     RACK_ENV = staging
     SECRET_KEY_BASE = xxxx
     RAILS_SKIP_ASSET_COMPILATION = false
     RAILS_SKIP_MIGRATIONS = false
     BUNDLE_WITHOUT = xxxx
     #  RDS
     RDS_HOST_NAME = xxxx
     RDS_USER_NAME = xxxx
     RDS_DB_NAME = xxxx
     RDS_DB_PASSWORD = xxxx
     #  For Mailer
     TNG_SENDER_ADDRESS=xxxx
     TNG_SENDER_DOMAIN=xxxx
     TNG_SENDER_PASSWORD=xxxx
     TNG_SENDER_USERNAME=xxxx
     #  API
     TNG_TWITTER_CONSUMER_KEY=xxxx
     TNG_TWITTER_CONSUMER_SECRET=xxxx
     TNG_FACEBOOK_APP_ID=xxxx
     TNG_FACEBOOK_APP_SECRET=xxxx

     #  AWS
     TNG_AWS_ACCESS_KEY_ID=xxxx
     TNG_AWS_SECRET_ACCESS_KEY=xxxx
     #  AWS S3
     TNG_S3_BUCKET=xxxx
     TNG_AWS_S3_REGION=xxxx
     #  AWS CLOUDSEARCH
     TNG_CLOUD_SEARCH_ENDPOINT_DOCUMENT=xxxx
     TNG_CLOUD_SEARCH_ENDPOINT_SEARCH=xxxx
     TNG_CLOUD_SEARCH_REGION=xxx
```

### React Js

creating a component via rails generate.

```bash
rails generate react:component ComponentName title:string --es6
```

usage

```javascript
//page_title.es6.jsx

class PageTitle extends React.Component {
  render() {
    return (
      <div className="page-title">
        <div className="title_left">
          <h3>{this.props.title}</h3>
        </div>
      </div>
    );
  }
}

PageTitle.propTypes = {
  title: React.PropTypes.string
};
```

```html
//index.html.erb <%= react_component('PageTitle', title:
'Admin::Dashboard#index') %>
<!-- or prerendered !-->
<%= react_component('PageTitle',{title: 'Admin::Dashboard#index'} , {prerender:
true}) %>

<div class="clearfix"></div>

<div class="row">
  <div class="x_panel">
    <div class="x_title">
      <h2>Dashboard#index</h2>
      <div class="clearfix"></div>
    </div>
    <div class="x_content">
      <p>Find me in app/views/admin/dashboard/index.html.erb</p>
    </div>
  </div>
</div>
```

rendering components instead of views

```ruby
class Controller < ApplicationController
  def index
    render component: 'PageTitle', props: { title: "title" }
  end
end
```

