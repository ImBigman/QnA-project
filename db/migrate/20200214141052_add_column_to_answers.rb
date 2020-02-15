class AddColumnToAnswers < ActiveRecord::Migration[6.0]
  def change
    add_column :answers, :best, :string, null: false, default: 'false'
  end
end
