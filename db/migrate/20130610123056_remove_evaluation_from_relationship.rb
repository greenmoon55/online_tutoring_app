# -*- encoding : utf-8 -*-
class RemoveEvaluationFromRelationship < ActiveRecord::Migration
  def change
    remove_column :relationships, :evaluation
    remove_column :relationships, :is_active
    remove_column :relationships, :evaluation_time
  end
end
