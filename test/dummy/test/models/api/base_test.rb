require 'test_helper'

class Api::BaseTest < ActiveSupport::TestCase

  def setup
    #Clear remote db
    cls_arr = [ Api::Item ]
    cls_arr.each do | cls |
      cls.all.each { |el| el.destroy }
    end
  end

end
