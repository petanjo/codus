Codus
=====

Tools to improve your life as Rails developer.



Javascript Organizer
--------------------

You can organize your javascript functions using cJS namespaces declaration and
the ones that matches your application name, current controller and current
action will automatic be fired.



### Setup



1. Put in your Gemfile:

gem 'codus'

2. Install the gem with *bundle install*

3. Put in your layout:

`<%= load_cjs(:app_name => 'yourappname') %>`

4. Put in your application.js

`//= require jquery`

`//= require cjs`

5. Declare your functions using cJS and enjoy your life



**Options**



**app_name**

The *load_cjs*** **helper method will print a javascript code, using query and
cJS, that calls namespaces matching the app_name option, current controller name
and current action name.



For instance, if you're in /posts/new it will call:



1. yourappname

2. yourappname.posts

3. yourappname.posts.new



**onload_method_name**

You can set the name of the last namespace to be called on the unload event with
the

<onload_method_name option. >For instance:



`<%= load_cjs(:app_name => 'yourappname', :onload_method_name =>
"myonloadmethod") %>`



If you're in /posts/new it will call:



1. yourappname.<myonloadmethod>

2. yourappname.posts.<myonloadmethod>

3. yourappname.posts.new.<myonloadmethod>



**method_names_mapper**

You can also configure equivalent namespaces using :<method_names_mapper. For
instance:>



`<%= load_cjs(:app_name => 'yourappname', `

                    ` :method_names_mapper => {`

                    `              :create => :new,`

                    `              :update => :edit`

                    `            }`

                    `)%>`



If you're in /posts/create it will call:



1. yourappname

2. yourappname.posts

3. yourappname.posts.create

4. yourappname.posts.new
