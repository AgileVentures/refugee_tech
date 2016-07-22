# Project Unify

This repo is for the Back-end Admin interface and API

Mobile client repo: https://github.com/AgileVentures/project_unify_mobile

 Service                 |  Status      |
|------------------------ | ----------------- |
| **Test coverage**         |                  |
| Coveralls                |  Not configured   |
| **Continuous integration** |    |
| Semaphore CI (master)       | Not configured|
| Semaphore CI (staging)       | Not configured|
| Semaphore CI (develop)      | [![Build Status](https://semaphoreci.com/api/v1/agileventures/project_unify/branches/develop/badge.svg)](https://semaphoreci.com/agileventures/project_unify)  |
| **Code quality**            |         |
| CodeClimate             | Not configured |
|**Deploys**                |         |
| Develop Server           | [unify-develop.herokuapp.com](http://unify-develop.herokuapp.com/) |
| Staging Server           |Not configured |
| Production Server        | Not configured |
|**Project management**       |         |
|Pivotal Tracker          |[Project Unify](https://www.pivotaltracker.com/n/projects/1525675)|
|**API Documentation**       |         |
| V1 Develop | [unify-develop.herokuapp.com/api-doc](http://unify-develop.herokuapp.com/api-doc)


### Features
#### Main
* User can sign up as a [Mentor](https://en.wiktionary.org/wiki/mentor#English) or [Mentee](https://en.wiktionary.org/wiki/mentee) 
* User can add Skills (Areas of interest) 
* User can search for matches
  * Mentors can serach for Mentees
  * Mentees can search for Mentors and other Mentees

#### Secondary
* User can send messages to other users
* User can access a Facebook timeline for the organisation running the system

### Setup instructions
Fork and clone the repository.

Run `bundle install` inside the projects folder

```shell
$ rails db:create
$ rails db:migrate
$ rails db:seed
```

#### Tests
The admin interface is primarely tested using Cucumber
Unit test are written in RSpec
API-endpoints are tested with Request specs `spec/requests/api/v1`


###Background
More than 700,000 refugees have made their way across the Mediterranean to Europe. The conflict in Syria continues to be by far the biggest driver of migration. But the ongoing violence in Afghanistan, abuses in Eritrea, as well as poverty in Kosovo and other regional conflicts are also leading people to look for new lives elsewhere. Many of the newly arrived refugees are highly skilled individuals, often with extensive professional experience. Others are young people who, because of war and the risk of persecution, was forced to interrupt their university studies.

I see the current migration situation as an opportunity for our societies to grow. I think that we can all benefit from people choosing Europe as their new home. But I also acknowledge that there are obstacles along the way when trying to settle down in a new country - in a different culture and different customs and traditions.

I have for some time been thinking of ways to assist refugees in their efforts to integrate into their new communities with help of technology and software. I think one of the areas which can benefit from technology, is assistance with integration into professional life and career development.

I would like to put together a team of developers and build a platform for established software engineers to get in touch with technically trained and interested migrants in order to help them start building their personal professional networks - which we all know are very important when entering the labor market.

I have a vision of an application that helps people get in touch and start interacting depending on interests, geographic location, age, and more.

It is my belief that it is a project that fits AgileVentures.org and that together we can create an interesting solution that will help at least some of the many people who long for a new, safe life in Europe.

/Thomas Ochamn ([@tochman](https://github.com/tochman))

###About AgileVentures

Agile Ventures is a non-profit organization dedicated to crowdsourced learning and project development. We run a [project incubator](http://www.agileventures.org/projects) that stimulates and supports development of social innovations, [open source projects and free software][oo-sw]. But first and foremost, we are a [place for learning][about-us] and personal development with [members][members] from across the world with various levels of competence and experience in software development.

We are proudly using Agile methods and Ruby on Rails as the framework to deliver well tested and solid software.

The principal organization behind this project is AgileVentures, a UK based charity.

