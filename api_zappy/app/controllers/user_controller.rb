class UserController < ApplicationController

  def get_logs
    user= User.find_by_email(session[:user_email])
    @user_log = user.log
    @server_log = user.server_log
  end

  def index
    @ranking = User.order(ranking: :desc)
    get_logs
    render 'index'
  end

  def upload
    get_logs
    dir_name = "delivery/" + session[:user_email]
    system 'mkdir', '-p', dir_name
    uploaded_io = params[:code]
    unless uploaded_io.nil?
      FileUtils.rm_rf(Dir.glob('delivery/' + session[:user_email] + '/*'))
      File.open(Rails.root.join('delivery', session[:user_email], uploaded_io.original_filename), 'w') do |file|
        file.write(uploaded_io.read.force_encoding(Encoding::UTF_8))
      end
      redirect_to '/menu', :flash => { success: "IA correctement upload" }
    else
      redirect_to '/upload', :flash => { error: "Erreur, aucun fichier reçu" }
    end
  end

  def ranking
    get_logs
    @ranking = User.order(ranking: :asc)
    render 'ranking'
  end

  def upload_get
    get_logs
    render 'upload'
  end

  def upload_code
    code = params[:code]
    unless code.nil?
      puts code
      FileUtils.rm_rf(Dir.glob('delivery/' + session[:user_email] + '/*'))
      File.open(Rails.root.join('delivery', session[:user_email], "zappy_ai"), 'w') do |file|
        file.write(code.force_encoding(Encoding::UTF_8))
      end
      redirect_to '/menu', :flash => { success: "IA correctement upload" }
    else
      redirect_to '/upload', :flash => { error: "Erreur, aucun code reçu" }
    end
  end

  def live_code
    get_logs
    render 'code'
  end

  def menu
    get_logs
    render 'menu'
  end
end
