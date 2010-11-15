# This file extends the Numeric class to provide simple utility for unit conversions.
# To properly use these extenstions, default units will/should be used:
# => MASS = kilograms
# => DISTANCE/MEASUREMENT = meters
# => TIME = seconds
# => VOLUME = fluid ounces 
#
# So, calling 3.pounds will return 1.36077711, which is the value converted to the base unit of kilograms.
#
# When retrieving the values, you can call one of the slew of to_* methods.
# => 5.km.to_miles -> 3.10685596118667
# whereas
# => 5.km -> 5000  (meters)
# 
class Numeric
  
  ##### MASS #####
  
  def kilograms
    self
  end
  alias :kilogram :kilograms
  alias :kg       :kilograms
  alias :kgs			:kilograms
  
  def pounds
    self * 0.45359237.kilograms
  end
  alias :pound  :pounds
  alias :lb     :pounds
  alias :lbs    :pounds

  def ounce
    self * 0.0283495231.kilograms
  end
  alias :oz     :ounce
  alias :ounces :ounce
  
  def stone
    self * 6.35029318.kilograms
  end
  alias :stones :stone

  def ton
    self * 907.18474.kilograms
  end
  alias :tons :ton
  
  
  ###### DISTANCE/MEASUREMENTS/LENGTH #####
  
  def meters
    self
  end
  alias :m     :meters
  alias :meter :meters
  
  def millimeters
    self * 0.001.meters
  end
  alias :mm         :millimeters
  alias :millimeter :millimeters
  
  def centimeters
    self * 0.01.meters
  end
  alias :cm         :centimeters
  alias :centimeter :centimeters
  
  def feet
    self * 0.3048.meters
  end
  alias :ft   :feet
  alias :foot :feet
  
  def inches
    self * 0.0254.meters
  end
  alias :in   :inches
  alias :inch :inches
  
  def yards
    self * 3.feet
  end
  alias :yd   :yards
  alias :yard :yards
  
  def miles
    self * 1609.344.meters
  end
  alias :mi   :miles
  alias :mile :miles
  
  def kilometers
    self * 1000.meters
  end
  alias :km        :kilometers
  alias :kilometer :kilometers
  
  
  #### TIME ####
  
  def seconds
    self
  end
  alias :second :seconds
  alias :secs   :seconds
  alias :sec    :seconds
  
  def minutes
    self * 60.seconds
  end
  alias :min    :minutes
  alias :minute :minutes
  alias :mins   :minutes
  
  def hours
    self * 60.minutes
  end
  alias :hr   :hours
  alias :hrs  :hours
  alias :hour :hours
  
  
  #### VOLUME #####
  
  def fluid_ounce
    self
  end
  alias :fluid_ounces :fluid_ounce
  alias :fl_oz        :fluid_ounce
  
  def teaspoon
    self * (1.0/6.0)
  end
  alias :teaspoons  :teaspoon
  alias :tsp        :teaspoon
  
  def tablespoon
    self * 0.5.fl_oz
  end
  alias :tablespoons  :tablespoon
  alias :tbsp         :tablespoon
  
  def cup
    self * 8.fl_oz
  end
  alias :cups :cup
  
  def pint
    self * 16.fl_oz
  end
  alias :pints :pint
  alias :pt    :pint
  
  def quart
    self * 16.fl_oz
  end
  alias :quarts :quart
  alias :qt     :quart
  
  # Helps convert back to a proper value
  def method_missing(method, *args)
    if match = /^to_([a-zA-Z_]*)$/.match(method.to_s)
      self / 1.send(match[1]).to_f
    else
      super
    end
  end
  
  # Call using something like to(:pounds)
  def to(unit)
    self.send("to_#{unit.to_s}")
  end
  
end