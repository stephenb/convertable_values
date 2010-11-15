require 'helper'

class TestConvertableValues < Test::Unit::TestCase
  
  P = 1**-10
  
  context "A Numeric object" do 
    should "auto-convert numbers properly to their value in the base unit" do
      assert_in_delta 1.pound, (1.kg * 0.45359237), P
      assert_in_delta 1.mile, (1.m * 1609.344), P
      assert_in_delta 1.hour, (1.sec * 60 * 60), P
      assert_in_delta 1.teaspoon, (1.0.fl_oz / 6.0), P
    end
    
    should "support to_unit" do
      assert_in_delta 354.3.to_pounds, 781.097795, P
      assert_in_delta 354.3.lbs.to_stones, 25.3071429, P
    end
    
    should "support to(:unit)" do
      assert_respond_to 354.3, :to
      assert_in_delta 354.3.to(:pounds), 781.097795, P
      assert_in_delta 354.3.lbs.to(:stones), 25.3071429, P
    end
    
    should "convert compatible numbers equally" do
      assert_equal 5.km, 5000.meters
      assert_equal 60.secs, 1.min
      assert_equal 3.feet, 1.yard
      assert_equal 3.1068559611866697.mi, 5.km
    end
  end
  
  context "A class that includes ConvertableValues" do
    setup do
      class AClassIncludingConvertableValues
        include ConvertableValues
        attr_accessor :value, :unit
        convert(:value, :unit)
      end
      @obj = AClassIncludingConvertableValues.new
      
      assert_nothing_raised do
        @obj.unit = 'mi'
        @obj.value = 3.10685596
      end
    end
    
    should "set the value converted to the base unit" do
      assert_in_delta @obj.instance_variable_get(:@value), 5000, P # Bypass accessor
    end
    
    should "return the inputted unit on normal access" do
      assert_in_delta @obj.value, 3.10685596, P
    end
    
    should "return the set unit" do
      assert_equal @obj.unit, 'mi'
    end
  end
  
  context "When setting the unit after the value" do
    setup do
      class AClassIncludingConvertableValues
        include ConvertableValues
        attr_accessor :value, :unit
        convert(:value, :unit)
      end
      @obj = AClassIncludingConvertableValues.new
      @obj.value = 3.10685596
    end
    
    should "return the inputted value before setting unit" do
      assert_equal @obj.value, 3.10685596
    end
    
    should "return nil unit" do
      assert_nil @obj.unit
    end
    
    should "return the converted value after setting unit" do
      @obj.unit = 'mi'
      assert_in_delta @obj.instance_variable_get(:@value), 5000, P # Bypass accessor
      assert_in_delta @obj.value, 3.10685596, P
    end
    
    should "return the value converted to the latest unit after setting unit multiple times" do
      @obj.unit = 'mi'
      @obj.unit = 'km'
      assert_in_delta @obj.instance_variable_get(:@value), 5000, P # Bypass accessor
      assert_in_delta @obj.value, 5, P
    end
  end
  
end
