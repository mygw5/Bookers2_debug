class CreateGroupUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :group_users do |t|
      t.reference :user, foreign_key: true
      t.reference :group, foreign_key: true
      t.timestamps
    end
  end
end
