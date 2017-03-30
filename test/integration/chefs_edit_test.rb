require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @chef = Chef.create!(chefname: "test", email: "test@email.com",
                         password: "password", password_confirmation: "password")
    @chef1 = Chef.create!(chefname: "taster", email: "taster@email.com",
                          password: "password", password_confirmation: "password")
    @admin_user = Chef.create!(chefname: "taster2", email: "taster2@email.com",
                          password: "password", password_confirmation: "password", admin: true)
  end
  
   test "reject an invalid edit" do
     sign_in_as(@chef, "password")
     get edit_chef_path(@chef)
     assert_template 'chefs/edit'
     patch chef_path(@chef), params: { chef: { chefname: " ", email: "test@email.com" } }
     assert_template 'chefs/edit'
     assert_select 'h2.panel-title'
     assert_select 'div.panel-body'
  end
 
 test "accept valid edit" do
   sign_in_as(@chef, "password")
   get edit_chef_path(@chef)
   assert_template 'chefs/edit'
   patch chef_path(@chef), params: { chef: { chefname: "taster", email: "taster@taster.com" } }
   assert_redirected_to @chef
   assert_not flash.empty?
   @chef.reload
   assert_match "taster", @chef.chefname 
   assert_match "taster@taster.com", @chef.email
 end
 
 test "accept edit attempt by admin user" do
   sign_in_as(@admin_user, "password")
   get edit_chef_path(@chef)
   assert_template 'chefs/edit'
   patch chef_path(@chef), params: { chef: { chefname: "taster3", email: "taster3@taster.com" } }
   assert_redirected_to @chef
   assert_not flash.empty?
   @chef.reload
   assert_match "taster3", @chef.chefname 
   assert_match "taster3@taster.com", @chef.email
 end
 
 test "redirect edit attempt by another non-admin user" do
   sign_in_as(@chef1, "password")
   updated_name = "joe"
   updated_email = "joe@email.com"
   patch chef_path(@chef), params: { chef: { chefname: updated_name, email: updated_email } }
   assert_redirected_to chefs_path
   assert_not flash.empty?
   @chef.reload
   assert_match "test", @chef.chefname 
   assert_match "test@email.com", @chef.email 
 end
  
end
