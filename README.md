## Fluent::Plugin::Switch

Filter plugin for [Fluentd](http://fluentd.org), similar to switch statements in PLs.

### Installation

    $ gem install fluent-plugin-switch  
 

### Configuration Guide

    <filter *>
      @type switch
      key_space                 # optional : add one or a list of comma sparated keys to be used for patttern matching, defaults to all					
      action                    # optional : append a new key or replace the value of an exisiting key, defaults to append        
      category_name             # optional : if appending, add this key to the record, if replacing, replaces the value of this key after matching, defaults to 'category' 
      default_value             # optional : if no matching condition found, uses this value, defaults to no action 
      <case>
        condition               # a regex condition to be used for matching
        value                   # if matched use this value
      </case>
    </filter>  



Example config (append):

    <filter *>
      @type                     switch
      key_space                 couleur					
      action                    append        
      category_name             english_color
      default_value             'no matching cases'
      <case>
        condition               '(couleur).+(rouge)'   
        value                   'red'        
      </case>
      <case>
        condition               '(couleur).+(jaune)'   
        value                   'yellow'       
      </case>
      <case>
        condition               '(couleur).+(bleu)'   
        value                   'blue'       
      </case>
     </filter>
     
     
Given the above config, if following JSON record is passed:  
    
    {"couleur":"La couleur est rouge"}
    
Then you get a new record like this : 

    {"couleur":"La couleur est rouge", "english_color" : "red"}
    
    
Example config (replace):

    <filter *>
      @type                     switch
      key_space                 couleur					
      action                    replace        
      category_name             couleur
      default_value             'no matching cases'
      <case>
        condition               '(couleur).+(rouge)'   
        value                   'red'        
      </case>
      <case>
        condition               '(couleur).+(jaune)'   
        value                   'yellow'       
      </case>
      <case>
        condition               '(couleur).+(bleu)'   
        value                   'blue'       
      </case>
     </filter>
     
     
Given the above config, if following JSON record is passed:  
    
    {"couleur":"La couleur est rouge"}
    
Then you get a new record like this : 

    {"couleur":"red"}    
    
    

Example config (default_value):

    <filter *>
      @type                     switch
      key_space                 couleur					
      action                    replace        
      category_name             couleur
      default_value             'no matching cases'
      <case>
        condition               '(couleur).+(rouge)'   
        value                   'red'        
      </case>
      <case>
        condition               '(couleur).+(jaune)'   
        value                   'yellow'       
      </case>
      <case>
        condition               '(couleur).+(bleu)'   
        value                   'blue'       
      </case>
     </filter>
     
     
Given the above config, if following JSON record is passed:  
    
    {"couleur":"La couleur est blanche"}
    
Then you get a new record like this : 

    {"couleur":"no matching cases"} 
    
    
***Note** : if the default_value config parameter is not present, and there is no matched patterns, the filter will act as a pass-thru.*