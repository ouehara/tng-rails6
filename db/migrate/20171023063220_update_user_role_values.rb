class UpdateUserRoleValues < ActiveRecord::Migration[6.0] 
  def change
    #registered: 0,  # can manage favorites, default value
    #curator: 1, # can post articles
    #editor: 2, # can manage articles
    #administrator: 3 # can manage all
    User.where("role=1").update_all(role: 10)
    User.where("role=2").update_all(role: 20)
    User.where("role=3").update_all(role: 30)
    
  end
end
