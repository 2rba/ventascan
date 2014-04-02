require 'rocketamf'
require 'rest_client'

module Ventascan
::RocketAMF::ClassMapper.define do |m|
  m.map :as => 'cl.pullman.websales.to.CiudadTO', :ruby => 'Ventascan::ObjectCuidadTo'
  m.map :as => 'cl.pullman.websales.to.EmpresaTO', :ruby => 'Ventascan::ObjectEmpresaTo'
  #m.map :as => 'vo.User', :ruby => 'Model::User'
end
class ObjectCuidadTo
  attr_accessor :codigo, :nombre
  #def initialize(codigo,nombre)
  #  @codigo = codigo
  #  @nombre = nombre
  #end
end
class ObjectEmpresaTo
  attr_accessor :empresaDominio
  attr_accessor :homeUrl
  attr_accessor :empresaCodigo
  attr_accessor :empresaDireccion
  attr_accessor :puntoVenta
  attr_accessor :empresaNombre
  attr_accessor :imageUrl
  attr_accessor :empresaCallcenter
  attr_accessor :applicationUrl
  def initialize
    self.empresaDominio = 'WWW.FULLPASS.CL'
    self.homeUrl = 'http://www.ventapasajes.cl/fullpass'
    self.empresaCodigo = '89'
    self.empresaDireccion = 'Casa Matriz: San Borja NÂº 235 - EstaciÃ³n Central - Santiago - Chile - Callcenter: 600 660 0011'
    self.puntoVenta ='WFP'
    self.empresaNombre='FULL PASS'
    self.imageUrl	= 'http://www.ventapasajes.cl/fullpass/images'
    self.empresaCallcenter='6006600011'
    self.applicationUrl = 'http://www.ventapasajes.cl/fullpassServer'
  end

end

class Venta
  class ErrorNameMissing < StandardError; end

  def search(from_name,to_name,date_date)
    #from_name = 'SANTIAGO'
    #to_name = 'PUCON'
    #date = Date.tomorrow.strftime('%d/%m/%Y')
    date = date_date.strftime('%d/%m/%Y')

    from_code = VentaCityMap.where(city_name:from_name).first
    raise ErrorNameMissing.new "no such name city name #{from_name}" unless from_code
    to_code = VentaCityMap.where(city_name:to_name).first
    raise ErrorNameMissing.new "no such name city name #{to_name}" unless to_code


    env = RocketAMF::Envelope.new :amf_version => 3
    msg =RocketAMF::Values::RemotingMessage.new
    msg.destination="ServiciosBean"
    msg.operation="getServicios"
    #msg.operation="getCiudadOrigen"
    msg.body=[]
    msg.body[0]=date
    msg.body[1]= ObjectCuidadTo.new.tap{|o| o.codigo =from_code[:city_id]; o.nombre=from_name }
    msg.body[2]= ObjectCuidadTo.new.tap{|o| o.codigo =to_code[:city_id]; o.nombre=to_name }
    msg.body[3]= "0000"
    msg.body[4]=0
    msg.body[5]=ObjectEmpresaTo.new
    msg.body[6]=1

    data = [msg]
    env.messages << RocketAMF::Message.new("null", '/15', data)
    RestClient.proxy = "http://127.0.0.1:8888"
    res = RestClient.post 'http://www.ventapasajes.cl/fullpassServer/messagebroker/amf', env.to_s, :content_type => 'application/x-amf'
    RocketAMF::Envelope.new.populate_from_stream(res).messages[0].data.body
    #.each{
    #  |h|
    #  p h
    #}
  end


  def update_cities
    env = RocketAMF::Envelope.new :amf_version => 3
    msg =RocketAMF::Values::RemotingMessage.new
    msg.destination="UsuariosBean"
    msg.operation="getCiudadesChile"
    #msg.operation="getCiudadOrigen"
    msg.body=[]
    data = [msg]
    env.messages << RocketAMF::Message.new("null", '/15', data)
    RestClient.proxy = "http://127.0.0.1:8888"
    res = RestClient.post 'http://www.ventapasajes.cl/fullpassServer/messagebroker/amf', env.to_s, :content_type => 'application/x-amf'
    RocketAMF::Envelope.new.populate_from_stream(res).messages[0].data.body.each{
      |h|
      p h
      m = VentaCityMap.where(city_name: h.nombre).first || VentaCityMap.new
      m.city_name = h.nombre
      m.city_id = h.codigo
      m.save!
    }
  end
end
end