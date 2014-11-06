# Ruby on Rails Tutorial: sample application

This is the sample application for [*Ruby on Rails Tutorial: Learn Rails by Example*](http://railstutorial.org/) by [Michael Hartl](http://michaelhartl.com/).

This sample has been modified to run on Cloud Foundry. The `cf-autoconfig` gem was added to enable auto-configuration of database connections as described in the [Cloud Foundry documentation](http://docs.cloudfoundry.com/docs/using/services/ruby-service-bindings.html). The `pg` gem was also added to support connection to PostgreSQL database. 

The CF version was *Hijacked* to show use of [user provided services](http://docs.cloudfoundry.org/devguide/services/user-provided.html) with [CouchDB](http://couchdb.apache.org/). The home page of the user writes posts to CouchDB, and displays the raw json of previous posts. No attempt has been made beyond that to replace use of SQL database.

## CouchDB setup
* install CouchDB and setup [httpd bind address](http://docs.couchdb.org/en/latest/config/http.html#httpd/bind_address) so that it's accessible from CF (i.e. don't use 127.0.0.1)
* Create the 'microposts' database
* Create the following design document
~~~ 
{
   "_id": "_design/posts",
   "language": "javascript",
   "views": {
       "all": {
           "map": "function(doc) { emit(null, { 'id': doc._id, 'user_id': doc.user_id, 'content': doc.content }); }"
       },
       "byuser": {
           "map": "function(doc) { emit(doc.user_id, { 'user_id': doc.user_id, 'content': doc.content }); }"
       }
   }
}
~~~

## Running the application on Cloud Foundry

After installing in the 'cf' [command-line interface for Cloud Foundry](http://docs.cloudfoundry.org/devguide/installcf/),
targeting a Cloud Foundry instance, and logging in, the application can be pushed using these commands:

First, view a list of services and plans available in your Cloud Foundry instance: 

~~~
$ cf marketplace
Getting services from marketplace
OK

service          plans                                                                 description
mongodb      default     MongoDB NoSQL database   
p-mysql      100mb-dev   A MySQL service for application development and testing   
postgresql   default     PostgreSQL database   
rabbitmq     default     RabbitMQ message queue   
redis        default     Redis key-value store  
~~~

Create a service instance named `mysql` using a MySql service and plan: 

~~~
$ cf create-service p-mysql 100mb-dev mysql
~~~

Create the user provided service for CouchDB:

~~~
$ cf create-user-provided-service couchdb -p '{ "url": "http://<couchdb ip/host>:5984/", "db": "microposts", "tag": "couchdb" }'
~~~

Now push the application: 

~~~
$ cf push
Using manifest file manifest.yml

Updating app rails-sample
OK

Creating route rails-sample-desiccative-acetylizer.cfapps.io...
OK

Binding rails-sample-desiccative-acetylizer.cfapps.io to rails-sample...
OK

Uploading rails-sample...
Uploading app files from: rails_sample_app
Uploading 41.1M, 6349 files
OK
Binding service rails-postgres to app rails-sample
OK

Starting app rails-sample
OK
...

0 of 1 instances running, 1 starting
0 of 1 instances running, 1 starting
0 of 1 instances running, 1 starting
1 of 1 instances running

App started

Showing health and status for app rails-sample
OK

requested state: started
instances: 1/1
usage: 256M x 1 instances
urls: rails-sample-desiccative-acetylizer.cfapps.io

     state     since                    cpu    memory          disk
#0   running   2014-05-29 03:34:22 PM   0.0%   50.3M of 256M   80.2M of 1G
~~~

The application will be pushed using settings in the provided `manifest.yml` file. The `--random-route` option adds random
words in the host to make sure the URL for the app is unique in the Cloud Foundry environment. The output of the
`cf push` command shows the URL that was assigned. Using the provided URL you can browse to the running application.
