class AutoUpgradeEverything < ActiveRecord::Migration
  def self.up
    Dir["#{Rails.root}/app/models/**/*.rb"].each do |model_path|
      model = File.basename(model_path, '.rb').camelcase.constantize
      if model.respond_to?(:auto_upgrade!)
        $stderr.puts "Running #{model.name}.auto_upgrade!"
        model.auto_upgrade!
      end
    end
  end

  def self.down
  end
end
