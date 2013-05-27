Codus
=====

Tools to improve your life as Rails developer.



Javascript Organizer
--------------------

You can write your javascript functions using [yojs namespaces declaration](https://github.com/codus/yojs). Namespaces that matches your application name, current controller and current action will automatic be fired.

### Setup



- Put in your Gemfile:

```ruby
gem 'codus'
```

- Install the gem with *bundle install*

- Put in your layout: 

`<%= load_yojs(:app_name => 'yourappname') %>`

- Put in your application.js

```javascript
//= require jquery
//= require yojs
```

- Declare your functions using yojs and enjoy your life



**Options**



***app_name***

The *load_yojs*** **helper method will print a javascript code, using query and yojs, that calls namespaces matching the app_name option, current controller name and current action name.



For instance, if you're in /posts/new it will call:



1. yourappname

2. yourappname.posts

3. yourappname.posts.new



***onload_method_name***

You can set the name of the last namespace to be called on the unload event with the *onload_method_name* option. For instance:


```erb
<%= load_yojs(:app_name => 'yourappname', :onload_method_name => "myonloadmethod") %>
```

If you're in /posts/new it will call:

1. yourappname.<myonloadmethod>

2. yourappname.posts.<myonloadmethod>

3. yourappname.posts.new.<myonloadmethod>


***method_names_mapper***

You can also configure equivalent namespaces using :<method_names_mapper. For instance:>



```erb
<%= load_yojs(:app_name => 'yourappname', 

                     :method_names_mapper => {

                                  :create => :new,

                                  :update => :edit

                                }

                    )%>
```

If you're in /posts/create it will call:

1. yourappname

2. yourappname.posts

3. yourappname.posts.create

4. yourappname.posts.new


File structure
--------------------

We recomend you to structure your js files according your namespace hierarchy. Example

- assets
  |- javascripts 
     |- application.js
     |- components (jquery, plugins, etc)
     |- myapp
     |  |- myapp.js (global javascripts in "myapp" namespace)
     |  |- controller1
     |  |  |- controller1.js (javascripts shared between "myapp.controller1" namespace)
     |  |  |- action1.js (javascripts for "myapp.controller1.action1" namespace)
     |  |  |- action2.js (javascripts for "myapp.controller1.action2" namespace)
     |  |  |- actionN.js (javascripts for "myapp.controller1.actionN" namespace)
     |  |  
     |  |- controller2
     |  |  |- controller2.js (javascripts shared between "myapp.controller2" namespace)
     |  |  |- action1.js (javascripts for "myapp.controller2.action1" namespace)
     |  |  |- action2.js (javascripts for "myapp.controller2.action2" namespace)
     |  |  |- actionN.js (javascripts for "myapp.controller2.actionN" namespace)
     |  |  
     |  |- controllerN
     |  |  |- controllerN.js (javascripts shared between "myapp.controllerN" namespace)
     |  |  |- ...
 
