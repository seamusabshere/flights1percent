# -*- encoding: utf-8 -*-
class AircraftModel < ActiveRecord::Base
  set_primary_key :code
  
  col :code
  col :manufacturer_name
  col :model_name
  
  data_miner do
    import("Importing aircraft from FAA",
            :url => 'http://registry.faa.gov/database/AR102011.zip', # october 2011
            :format => :fixed_width,
            :filename => 'ACFTREF.txt',
            :schema => [[ 'code', 7, { :type => :string }  ],
                        [ 'spacer',  1 ],
                        [ 'manufacturer_name', 30, { :type => :string } ],
                        [ 'spacer',  1 ],
                        [ 'model_name', 20, { :type => :string } ]]
            ) do
      key 'code'
      store 'manufacturer_name'
      store 'model_name'
    end
  end
end

# == Schema Information
#
# Table name: aircraft_models
#
#  code              :string(255)     not null, primary key
#  manufacturer_name :string(255)
#  model_name        :string(255)
#

