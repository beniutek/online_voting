class ReworkConfigurations < ActiveRecord::Migration[6.0]
  def change
    add_column :configurations, :active, :boolean, default: false
  end
end
