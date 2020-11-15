class TasksController < ApplicationController
  def index
    @tasks =Task.all
  end

  def show
    @task =Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def edit
    @task =Task.find(params[:id])
  end

  # updateとcreateはビューで表示しないので@いらない
  def update
    @task =Task.find(params[:id])
    # new(task_params)のパラメータ受け取る部分とsave!を同時にやってるイメージ(ただしnewのようにオブジェクトを新規作成する必要はない)
    if @task.update(task_params)
      redirect_to tasks_url, notice: "タスク「#{@task.name}」を更新しました。"
    else
      render :edit
    end
  end

  def create
    @task = Task.new(task_params)
    # task.save!
    # redirect_to tasks_url, notice: "タスク「#{task.name}」を登録しました。"
    if @task.save
      redirect_to tasks_url, notice: "タスク「#{@task.name}」を登録しました。"
    else
      render :new
    end
  end

  def destroy
    @task =Task.find(params[:id])
    @task.destroy
    redirect_to tasks_url, notice: "タスク「#{@task.name}」を削除しました。"
  end


  private
  def task_params
    params.require(:task).permit(:name, :description)
  end
end
