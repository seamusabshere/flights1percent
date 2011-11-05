class Aircraft < ActiveRecord::Base
  set_primary_key :tail_number
  
  col :tail_number
  col :manufacturer_model_code
  # col :manufacturer_name
  # col :model_name
  
  belongs_to :model, :class_name => 'AircraftModel', :foreign_key => 'manufacturer_model_code'
  
  data_miner do
    process "make sure models have been populated" do
      AircraftModel.run_data_miner!
    end
    
    import("Importing aircraft from FAA",
      # :url => 'http://registry.faa.gov/database/AR102011.zip', # make sure to update the date part of this filename
      :url => 'file:///Users/seamusabshere/code/flights1percent/AR102011.zip',
      :format => :fixed_width,
      :filename => 'MASTER.txt',
      :schema => [[ 'tail_number', 5, { :type => :string }  ],
                  [ 'spacer',  1 ],
                  [ 'serial_number', 30, { :type => :string } ],
                  [ 'spacer',  1 ],
                  [ 'manufacturer_model_code', 7, { :type => :string } ]]
      ) do
      key 'tail_number'
      store 'manufacturer_model_code'
    end
  end
end
