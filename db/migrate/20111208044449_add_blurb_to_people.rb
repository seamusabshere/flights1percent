class AddBlurbToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :blurb, :text
  end

  def self.down
    remove_column :people, :blurb
  end
end
