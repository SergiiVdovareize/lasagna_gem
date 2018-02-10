# lasagna_gem
An extremely light ruby gem for jsonapi parsing

# Install

As usual, paste this line into your command line

    gem install lasagna
    
or add this line into your `Gemfile`
    
    gem 'lasagna'

## Usage
First, add this line into a needed class or module:

    require 'lasagna'
    
That's it, you can start using it:

    Lasagna.parse([JSON], [OPTIONS])
    # [JSON] - parsed jsonapi string (use JSON.parse for example)
    # [OPTIONS] - optional params for parsing
    # Here is default parse options:
    #   { include_ids: true,
    #     include_types: true,
    #     transform_keys: nil } # transform_keys is not supported yet

##Links

- [JSON.parse](http://ruby-doc.org/stdlib-2.0.0/libdoc/json/rdoc/JSON.html) - Parses a json string into a ruby hash object.
- [json:api](http://jsonapi.org/) - Json format we are talking about here. You can find the full specification and links for other implementations there.
