require 'yajl'

namespace :index do
  desc "Fill database with sample data"
  task destroy_all: :environment do
    find_and_delete_indices
  end
end

def find_and_delete_indices
  Yajl::Parser.parse(Tire::Configuration.client.get("#{Tire::Configuration.url}/_aliases").body).keys.each do |ind|
    Tire.index ind do
      delete
    end
  end
end
