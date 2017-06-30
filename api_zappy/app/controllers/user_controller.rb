# coding: utf-8

require 'net/http'
require 'json'


class UserController < ApplicationController

  def get_logs
    @user = User.find_by_email(session[:user_email])
    @user_log = @user.log
    @server_log = @user.server_log
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
      redirect_to '/ranking', :flash => { success: "IA correctement upload" }
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
    if can_upload(session[:user_email]) == false
      render 'auth/error'
      return
    end
    unless code.nil?
      puts code
      FileUtils.rm_rf(Dir.glob('delivery/' + session[:user_email] + '/*'))
      File.open(Rails.root.join('delivery', session[:user_email], "zappy_ai"), 'w') do |file|
        file.write(code.force_encoding(Encoding::UTF_8))
      end
      redirect_to '/ranking', :flash => { success: "IA correctement upload" }
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
    render 'ranking'
  end

  private
  def can_upload(user_name)
    url2 = 'https://intra.epitech.eu/auth-ded102aa843dc494f2e69873c00fc05194d95a64/user/' + user_name +'/notes/?format=json'
    content2 = open(url2).read
    if content2.nil?
      return false
    end
    data2 = JSON.parse(content2)
    if data2.nil?
      return false
    end
     
    if data2["modules"].nil?
      return false
    end
    in_mod = false
    data2["modules"].each do |mod|
      if mod["codemodule"] == "B-PSU-335"
        in_mod = true
        break
      end
    end
    if in_mod === false
      return false
    end
    return true
  end
end
