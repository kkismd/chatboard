class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :title
      t.string :serial
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
