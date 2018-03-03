require_relative 'db_connection'
require 'active_support/inflector'
require 'byebug'

# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject

  def self.columns
    return @columns if @columns
    cols = DBConnection.execute2(<<-SQL)
  SELECT
    *
  FROM
    #{self.table_name}
    SQL

    cols = cols[0].map {|el| el.to_s.to_sym}
    @columns = cols
  end

  def self.finalize!
    self.columns.each do |col|
      define_method(col) do
        self.attributes[col]
      end

      define_method("#{col}=") do |value|
        self.attributes[col] = (value)
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    if @table_name
      @table_name
    else
      @table_name = self.to_s.tableize
    end
  end

  def self.all
    results = DBConnection.execute(<<-SQL)
  SELECT
    #{table_name}
  FROM
    #{table_name}
    SQL
    parse_all(results)
  end

  def self.parse_all(results)
     results.map { |result| self.new(result) }
  end

  def self.find(id)
    # ...
  end

  def initialize(params = {})
    params.each do |attr_name, value|
    attr_name = attr_name.to_sym
    if self.class.columns.include?(attr_name)
      self.send("#{attr_name}=", value)
    else
      raise "unknown attribute '#{attr_name}'"
    end
  end


  def attributes
    @attributes ||= {}
  end

  def attribute_values
    @attributes.values
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
