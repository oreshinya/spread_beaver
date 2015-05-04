# SpreadBeaver
Server side Javascript runner in Ruby on Rails.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'spread_beaver', github: "oreshinya/spread_beaver"
```

## Getting Started

### Edit config/application.rb
```
# These are the defaults if you dont specify any yourself
config.spread_beaver.pool_size = 10 #ExecJS instance size
config.spread_beaver.timeout = 20 #ExecJS timeout
config.spread_beaver.bundle = "server-side-bundle.js" #Javascript file placed at under app/assets/javascripts
```

### Create config/initializers/spread_beaver.rb
```
module SpreadBeaver
  class Runner
    # Execute javascript in javascript context before every SpreadBeaver::Runner.exec
    def initialize_script
      "clearAllStores();"
    end

    # Execute queued javascript in javascript context before every SpreadBeaver::Runner.exec
    def exec_queued_module module_name, props
      "#{module_name}.init(#{props_to_s(props)});"
    end

    # Execute javascript by SpreadBeaver::Runner.exec
    def exec_module module_name, props
      "#{module_name}.render(#{props_to_s(props)});"
    end
  end
end
```

## API

- **SpreadBeaver::Runner.queue(module_name, props)**:  
Push hash that has passed values to request store.  
Execute `exec_queued_module` with stored hash data.

- **SpreadBeaver::Runner.exec(module_name, props)**:  
Execute `exec_module` with connection pooling.
