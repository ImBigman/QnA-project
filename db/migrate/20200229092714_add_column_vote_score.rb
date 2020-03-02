class AddColumnVoteScore < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :vote_score, :integer, default: 0
    add_column :answers, :vote_score, :integer, default: 0
  end
end
