class LandingRoute < Sinatra::Base
  get '/' do
    HAL::LandingRepresenter.new({}).to_json
  end
end
