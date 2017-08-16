class Fluent::AddFilter < Fluent::Filter
  Fluent::Plugin.register_filter('switch', self)

  config_param :tag, :string, :default => 'switch.event'
  config_param :key_space, :string, :default => 'all'
  config_param :action, :string,    :default => 'append'
  config_param :category_name, :string, :default => 'category'
  config_param :default_value, :string, :default => nil

  def initialize
    super
  end

  def configure(conf)
    super
    # config file validations
    if !['append', 'replace'].include? action
       raise Fluent::ConfigError, "undefined action, select: 'append' or 'replace'"
    end

    # do more config validation
    ###

    # create the condition / value array
    @list = []
    conf.elements.select { |element| element.name == 'case' }.each do |element|
      element_hash = element.to_hash
      if ['condition', 'value'].all? {|s| element_hash.key? s}
        map = { 'condition' => element_hash['condition'], 'value' => element_hash['value']}
        @list.push(map)
      else
        raise Fluent::ConfigError, "use 'condtion' key for pattern matching, and use 'value' key for replacement value"
      end
    end
  end

  # method to remap based the conditions in the config
  def revalue(record)

    # create the string to be compared against conditions
    payload = ''
    if key_space == 'all'
     array = record.each{|key, value| value}
     payload = array.join(',')
    else
      keys = key_space.split(',')
      if keys.all? {|elem| record.key? elem}
          keys.each do |key|
            payload = payload + record[key]    
          end
      else
        raise Fluent::ConfigError, "one or more keys provided don't exist in the record"
      end
    end
    @list.each do |hash|
      regex_pattern = Regexp.new hash['condition']
      if regex_pattern =~ (payload)
        return hash['value']
      end
    end
    return (default_value) ? default_value : record[category_name]
  end


  def filter(tag, time, record)
    pass_thru = record
    begin
      value = revalue(record)
      if action == 'append'
        record = record.merge!(category_name => value)
      else
        if record.has_key? category_name
          record[category_name] = value
        else
          raise Fluent::ConfigError, "can't find the key in record to replace its value"
        end
      end
    rescue Exception => e
      log.error e.message
      log.error e.backtrace.inspect
      log.info 'an exception occurred while filtering, returning the original record'
      return pass_thru
    end
    record
  end
end