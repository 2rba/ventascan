install this as gem

    gem 'ventascan', git: 'https://github.com/2rba/ventascan.git'

Requests are done with city codes, so before using search should be created map: name -> code

Map is stored within database table 'venta_city_maps'

to create it use

    rails generate ventascan:migration
    rake db:migrate


before first use map table should be updated with

    Ventascan::Venta.new.update_cities

do search by

    Ventascan::Venta.new.search('SANTIAGO','PUCON',Date.tomorrow)
