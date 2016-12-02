# New attr_reader, attr_writer, and attr_accessor methods that notify the users with puts
module Notify
  def self.attr_reader(*vars)
    vars.each do |var|
      class_name.class_eval "def #{var};"\
                      "puts \"The value of @\#{__callee__} is \\\"\#{@#{var}}\\\" (\#{@#{var}.class})\";"\
                      "@#{var};"\
                      'end'
    end
  end

  def self.attr_writer(*vars)
    vars.each do |var|
      class_name.class_eval "def #{var}=(value);"\
                      "puts \"Setting @#{var} to \\\"\#{value}\\\" (\#{value.class})\";"\
                      "@#{var} = value;"\
                      'end'
    end
  end

  def self.attr_accessor(*vars)
    attr_reader(*vars)
    attr_writer(*vars)
  end

  def self.class_name
    begin
      raise
    rescue => error
      return Object.const_get((/<class:(.+)>'$/).match(error.backtrace.join("\n"))[1])
    end
  end

  private_class_method :class_name
end
