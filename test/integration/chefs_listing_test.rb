require 'test_helper'

class ChefsListingTest < ActionDispatch::IntegrationTest
  
   def setup
    @chef = Chef.create!(chefname: "test", email: "test@email.com",
                         password: "password", password_confirmation: "password")
    @chef1 = Chef.create!(chefname: "taster", email: "taster@email.com",
                          password: "password", password_confirmation: "password")
   end
  
  test "should get chefs listing" do
    get chefs_path
    assert_template 'chefs/index'
    assert_select "a[href=?]", chef_path(@chef), text: @chef.chefname.capitalize
    assert_select "a[href=?]", chef_path(@chef1), text: @chef1.chefname.capitalize
  end
end
