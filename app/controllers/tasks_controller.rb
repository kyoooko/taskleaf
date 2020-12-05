class TasksController < ApplicationController
  before_action :set_task,only:[:show,:edit,:update,:destroy]
  def index
    # @tasks =Task.all
    # モデルのスコープ（データの絞り込みの③実行部分をまとめられるもの）で代わりに記載
    # @tasks =current_user.tasks.order(created_at: :desc)
    # @tasks =current_user.tasks.recent
    # 下記と同じ
    # @tasks =Task.where(user_id:current_user.id).recent

    @q=current_user.tasks.ransack(params[:q])
    # recentはorder byをモデルでスコープにしたもの
    # @tasks = @q.result(distinct: true).recent
    @tasks = @q.result(distinct: true)
  end

  def show
    # @task =Task.find(params[:id])
    # 上記だとブラウザで直入力されると見えてしまうため下記実装
    # @task =current_user.tasks.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def confirm_new
    @task = current_user.tasks.new(task_params)
    # binding.pry
    render :new unless @task.valid?
  end

  def create
    # @task = Task.new(task_params)
    #  @task = Task.new(task_params.merge(user_id:current_user.id)
    # 「アソシエーション.new」の場合、FKのカラムuser_idには自動的に current_userのID入る
    @task = current_user.tasks.new(task_params)

    if params[:back].present?
      render :new
      return
    end
    # task.save!
    # redirect_to tasks_url, notice: "タスク「#{task.name}」を登録しました。"
    if @task.save
      TaskMailer.creation_email(@task).deliver_now
      logger.debug "==============デバッグ用=============task: #{@task.attributes.inspect}"
      redirect_to tasks_url, notice: "タスク「#{@task.name}」を登録しました。"
    else
      render :new
    end
  end

  def edit
    # @task =Task.find(params[:id])
    # @task =current_user.tasks.find(params[:id])
  end

  # updateとcreateはビューで表示しないので@いらない
  def update
    # @task =Task.find(params[:id])
    # @task =current_user.tasks.find(params[:id])
    # new(task_params)のパラメータ受け取る部分とsave!を同時にやってるイメージ(ただしnewのようにオブジェクトを新規作成する必要はない)
    if @task.update(task_params)
      redirect_to tasks_url, notice: "タスク「#{@task.name}」を更新しました。"
    else
      render :edit
    end
  end

  def destroy
    # @task =current_user.tasks.find(params[:id])
    @task.destroy
    redirect_to tasks_url, notice: "タスク「#{@task.name}」を削除しました。"
  end


  private
  def task_params
    params.require(:task).permit(:name, :description)
  end

  def set_task
    @task =current_user.tasks.find(params[:id])
  end
end
