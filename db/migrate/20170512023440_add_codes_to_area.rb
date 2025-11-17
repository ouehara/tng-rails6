class AddCodesToArea < ActiveRecord::Migration[6.0] 
  def change
    add_column :areas, :area_code, :int
    add_column :areas, :prefecture_code, :int
  end
end
