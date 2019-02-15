# frozen_string_literal: true

def sql_out
  ActiveRecord::Base.logger = Logger.new(STDOUT)
end
