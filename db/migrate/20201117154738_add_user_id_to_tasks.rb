class AddUserIdToTasks < ActiveRecord::Migration[5.2]
  def up
    # 今まで作られたタスク全て削除
    execute 'DELETE FROM tasks;'
    add_reference :tasks,:user,index: true
  end

  def down
    add_reference :tasks,:user,index: true
  end
end
