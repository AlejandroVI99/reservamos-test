class DestinationService
  API_TOKEN = ENV['OPENWEATHER_API_TOKEN']

  def self.get_destination(city)
    new(city).call
  end

  def initialize(city)
    @city = city
  end

  def call
    cities = fetch_cities(@city)
    add_weather_to_cities(cities)
  end

  private

  def fetch_cities(city)
    url = "https://search.reservamos.mx/api/v2/places?q=#{city}"
    response = RestClient.get(url)
    result = JSON.parse(response.to_s)
    result.select { |x| x['country'] == 'México' && x['result_type'] == 'city' }
  rescue RestClient::ExceptionWithResponse => e
    Rails.logger.error "Error fetching cities: #{e.message}"
    []
  end

  def add_weather_to_cities(cities)
    part = 'current,minutely,hourly,alerts'

    cities.each do |city|
      lat = city['lat']
      long = city['long']
      weather_data = fetch_weather_data(lat, long, part)

      city.merge!(
        'min_temp' => weather_data['min_daily_temp'],
        'max_temp' => weather_data['max_daily_temp'],
        'daily_temps' => weather_data['daily']
      )
    end

    cities.sort_by { |x| x['min_temp'] }
  end

  def fetch_weather_data(lat, long, part)
    url = "https://api.openweathermap.org/data/3.0/onecall?lat=#{lat}&lon=#{long}&exclude=#{part}&units=metric&appid=#{API_TOKEN}"
    response = RestClient.get(url)
    response_json = JSON.parse(response.to_s)

    process_weather_data(response_json)
  rescue RestClient::ExceptionWithResponse => e
    Rails.logger.error "Error fetching weather data: #{e.message} - Status: #{e.response.code}, Body: #{e.response.body}"
    { 'daily' => [ { 'temp' => { 'min' => 0, 'max' => 0 } } ] }
  end

  def process_weather_data(response_json)
    daily = response_json['daily'].drop(1).map do |daily_temp|
      {
        'date' => Time.at(daily_temp['dt']).strftime('%Y-%m-%d'),
        'min_daily_temp' => daily_temp['temp']['min'],
        'max_daily_temp' => daily_temp['temp']['max']
      }
    end

    min_daily_temp = daily.map { |day| day['min_daily_temp'] }.min
    max_daily_temp = daily.map { |day| day['max_daily_temp'] }.max

    {
      'daily' => daily,
      'min_daily_temp' => min_daily_temp,
      'max_daily_temp' => max_daily_temp
    }
  end
end
