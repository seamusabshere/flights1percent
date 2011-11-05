class CreateAircraftRegistrations < ActiveRecord::Migration
  def self.up
    create_table :aircraft_registrations do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :aircraft_registrations
  end
end
