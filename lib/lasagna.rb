class Lasagna
  def self.parse(json)
    if json.nil? || json['data'].nil?
      return {}
    end

    inclusion = parse_inclusion json
    parsed = []

    json['data'].each do |item|
      row = item['attributes'].transform_keys { |key| key.to_s.underscore }
      item['relationships'].each do |key, r|
        type = r['data']['type'].underscore
        id = r['data']['id']
        row[key] = inclusion[type] && inclusion[type][id]
      end
      parsed.push row
    end
    parsed
  end

  private

  def self.parse_inclusion(json)
    inclusion = {}
    included = json['included'] || []
    included.each do |include|
      key = include['type'].underscore
      inclusion[key] = {} if inclusion[key].nil?
      inclusion[key][include['id']] = include['attributes'].transform_keys { |key| key.to_s.underscore }
    end
    inclusion
  end
end
