require 'rails_admin/config/fields/base'

module RailsAdmin::Config::Fields::Types
  class Citext < RailsAdmin::Config::Fields::Types::String
    RailsAdmin::Config::Fields::Types::register(:citext, self)
  end
end