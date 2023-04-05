class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]
  before_action :set_ranking_data, only: [:index, :show]

  def index
    @articles = Article.all
  end

  def show
    @article = Article.find_by(id: params[:id])
    @user = User.find_by(id: @article.user_id)
    # Redisにデータをセット
    REDIS.zincrby "articles", 1, "#{@article.id}"
  end

  # Redisのpvランキング上位3を抽出
  def set_ranking_data
    ids = REDIS.zrevrangebyscore "articles", "+inf", 0, limit: [0, 3]
    @ranking_articles = ids.map{ |id| Article.find(id) }
  end

  def new
  end

  def create
    @article = Article.new(article_params)
    @article.save
    redirect_to("/articles/#{@article.id}")
  end

  def edit
    @article = Article.find_by(id: params[:id])
  end

  def update
    @article = Article.find_by(id: params[:id])
    @article.update(article_params)
    redirect_to("/articles/#{@article.id}")
  end

  def destroy
    @article = Article.find_by(id: params[:id])
    # 対応するRedisのデータを削除
    REDIS.zrem "articles", "#{@article.id}"
    @article.destroy
    redirect_to("/")
  end

  
  private
  # ストロングパラメータ
  def article_params
    params.permit(:title, :content).merge(user_id: current_user.id)
  end

  # 権限認証
  def ensure_correct_user
    @article = Article.find_by(id: params[:id])
    if current_user.id != @article.user_id
      flash[:notice] = 'Not yours'
      redirect_to("/")
    end
  end
end
