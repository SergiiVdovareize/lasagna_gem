class Lasagna
  DEFAULT_OPTIONS = { include_ids: true,
                      include_types: true,
                      transform_keys: nil } # transform_keys is not supported yet

  def self.parse(json, options = {})
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

  def self.parse_inclusion(json, options)
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
