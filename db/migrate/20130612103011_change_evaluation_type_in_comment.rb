class ChangeEvaluationTypeInComment < ActiveRecord::Migration
  def up
    change_column :Comments, :evaluation, :string
  end

  def down
    change_column :Comments, :evaluation, :integer
  end
end
