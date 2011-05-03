require 'numeric/numeric_units'

module ConvertableValues
  
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    
    # Calling convert(value_attr_name, unit_attr_name) will set up that 
    # pair of value/unit attributes to automatically convert the valu to/from the 
    # given unit's base unit.
    def convert(value_attr, unit_attr)
      # Create override method for converting value to base unit when set
      define_method "#{value_attr}=".to_sym do |new_value|
        unit_str = send(unit_attr.to_sym)
        
        if new_value && unit_str
          # store the value converted to the base unit corresponding to the given unit
          if respond_to?(:write_attribute, true)
            write_attribute(value_attr.to_sym, new_value.send(unit_str))
          else
            instance_variable_set("@#{value_attr}".to_sym, new_value.send(unit_str))
          end
        else
          if respond_to?(:write_attribute, true)
            write_attribute(value_attr.to_sym, new_value)
          else
            instance_variable_set("@#{value_attr}".to_sym, new_value)
          end
        end
      end
      
      # Create override method for converting value to stored unit when accessed
      define_method value_attr.to_sym do
        unit_str = send(unit_attr.to_sym)
        
        if unit_str
          # return the value converted back to whatever unit was stored
          if respond_to?(:read_attribute, true)
            read_attribute(value_attr.to_sym).to(unit_str.to_sym)
          else
            instance_variable_get("@#{value_attr}".to_sym).to(unit_str.to_sym)
          end
        else
          if respond_to?(:read_attribute, true)
            read_attribute(value_attr.to_sym)
          else
            instance_variable_get("@#{value_attr}".to_sym)
          end
        end
      end
      
      # Create override method for updating value when unit is set/changed
      define_method "#{unit_attr}=".to_sym do |new_unit|
        if respond_to?(:read_attribute, true)
          old_unit = read_attribute(unit_attr.to_sym)
        else
          old_unit = instance_variable_get("@#{unit_attr}".to_sym)
        end
        
        if respond_to?(:write_attribute, true)
          write_attribute(unit_attr.to_sym, new_unit)
        else
          instance_variable_set("@#{unit_attr}".to_sym, new_unit)
        end
      
        # Re-assign the value so it will be converted properly
        if respond_to?(:read_attribute, true)
          value = read_attribute(value_attr.to_sym)
        else
          value = instance_variable_get("@#{value_attr}".to_sym)
        end
        send("#{value_attr}=".to_sym, value) if value && old_unit.nil?

        new_unit
      end
    end
  
    #### Base Units ####
  
    def base_mass_unit
      :kilograms
    end
  
    def base_volume_unit
      :fluid_ounce
    end

    def base_length_unit
      :meters
    end

    def base_time_unit
      :seconds
    end
    
  end

end
