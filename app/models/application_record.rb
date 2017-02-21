# Application Record
require 'csv'

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
