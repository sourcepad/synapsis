def get_random_routing_number
  # Taken from: https://www.usbank.com/checking/aba-routing-number.html, we cannot just generate random numbers as the tests have a tendency to fail
  sample_routing_numbers = ['122105155', '082000549', '121122676', '122235821', '102101645', '102000021', '123103729']

  sample_routing_numbers.sample
end

