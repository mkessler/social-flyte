[ ![Codeship Status for mkessler/yoala](https://app.codeship.com/projects/c3298b20-7cae-0134-5149-164a30546007/status?branch=master)](https://app.codeship.com/projects/181143)

SocialFlyte
==============================================

SocialFlyte is a social media campaign analysis tool that allows users to easily import and consume post interactions across today's most popular social networks. SocialFlyte enables end users the ability to monitor cross-network campaigns and digest engagement in an intuitive, meaningful way.


Required Environment / Minimum Setup
----------------------------------------------

Requirements:

* Ruby (v2.3.0)
* Rails (v5.0.0.1)
* PostgreSQL (v9.5.4)

Setup:

1. Clone repo `git clone git@bitbucket.org:USERNAME/socialflyte.git`
2. `cd socialflyte`
3. `./bin/setup`

Notable Deviations
----------------------------------------------

Document any case where this project deviates from the standard policies.
Not using git flow? What's the branching model.
Esoteric release schedule? Document it.


Accessing the Site
----------------------------------------------

Is it running WEBrick, pow, unicorn?
Do you need to use custom subdomains or hosts?


Configuration
----------------------------------------------

Who do I speak with to get the values for configuration files?
Who/where do I go to for dev/production database dumps?


Walkthrough / Smoke Test
----------------------------------------------

Describe a manual smoke test process to ensure that the env is running as it should be.


Testing
----------------------------------------------

Tests are run using [RSpec](https://relishapp.com/rspec).


To run the entire test suite use the following command:
`bundle exec rspec`


Acceptance tests are enabled by [Capybara](https://github.com/teamcapybara/capybara#using-capybara-with-rspec).


When in need of dummy data, [Faker](https://github.com/stympy/faker#usage) is used to generate random, realistic data on the fly.


Staging Environment
----------------------------------------------

Where is it?
How do I access it?
Who do I speak with to get access?


Production Environment
----------------------------------------------

Where is it?
 - Heroku

How do I access it?
 - https://heroku.com or using [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli)

How do I deploy?
 - Add Heroku remote

 `git remote add heroku https://git.heroku.com/socialflyte.git`
 - Push changes to Heroku

 `git push heroku master`

Design
----------------------------------------------

SocialFlyte uses [Material Bootsrap Design](http://mdbootstrap.com/components/).


Known Issues / Gotcha
----------------------------------------------



Extended Resources
----------------------------------------------

link to extended resources
