class Lasagna
  DEFAULT_OPTIONS = { include_ids: true,
                      include_types: true,
                      transform_keys: nil } # transform_keys is not supported yet

  class << self
    # Parses jsonapi into a flat readable ruby hash object
    #
    # Arguments:
    #   json: (Hash) parsed jsonapi string
    #   options: (Hash) (optional) parsing params
    #
    def parse(json, options = {})
      if json.nil? || json['data'].nil?
        return {}
      end

      options = DEFAULT_OPTIONS.merge options
      inclusion = parse_inclusion(json, options)
      parsed = []

      json['data'].each do |item|
        row = {}
        if options[:include_ids]
          row['id'] = item['id']
        end

        if options[:include_types]
          row['type'] = item['type']
        end

        row = row.merge item['attributes']
        unless item['relationships'].nil?
          item['relationships'].each do |key, r|
            next if r['data'].nil?
            type = r['data']['type']
            id = r['data']['id']
            row[key] = inclusion[type] && inclusion[type][id]
          end
        end
        parsed.push row
      end
      parsed
    end

    private

    def parse_inclusion(json, options)
      inclusion = {}
      included = json['included'] || []
      included.each do |include|
        key = include['type']
        inclusion[key] = {} if inclusion[key].nil?
        inc = {}

        if options[:include_ids]
          inc['id'] = include['id']
        end
        if options[:include_types]
          inc['type'] = include['type']
        end

        inclusion[key][include['id']] = inc.merge include['attributes']
      end
      inclusion
    end
  end

end


# NoMethodError: undefined method `[]' for nil:NilClass
# /home/dedal/.rvm/gems/ruby-2.3.3/gems/lasagna-0.1.2/lib/lasagna.rb:13:in `block (2 levels) in parse'
# /home/dedal/.rvm/gems/ruby-2.3.3/gems/lasagna-0.1.2/lib/lasagna.rb:12:in `each'
# /home/dedal/.rvm/gems/ruby-2.3.3/gems/lasagna-0.1.2/lib/lasagna.rb:12:in `block in parse'
# /home/dedal/.rvm/gems/ruby-2.3.3/gems/lasagna-0.1.2/lib/lasagna.rb:10:in `each'
# /home/dedal/.rvm/gems/ruby-2.3.3/gems/lasagna-0.1.2/lib/lasagna.rb:10:in `parse'