class AddIndexToMessages < ActiveRecord::Migration
  def change
    add_index :messages, [:sender_id, :receiver_id]
  end
end
