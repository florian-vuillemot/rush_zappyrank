require 'open-uri'
require 'json'

class ApplicationController < ActionController::Base
  before_action :current_user, :except => [:login, :gettoken]
  helper_method :user_logged_in, :current_user

  def get_user_data(user_name, user)
    url = 'https://intra.epitech.eu/auth-ded102aa843dc494f2e69873c00fc05194d95a64/user/' + user_name +'/?format=json'
    '''
    uri = URI(url)

    res = Net::HTTP.get(uri)
    '''
    content = open(url).read
    if content.nil?
      return false
    end

    data = JSON.parse(content)
    if data.nil?
      return false
    end
    puts data

    city = data["location"].split("/")[1]
    promo = data["promo"]

    if city.nil? or promo.nil?
      return false
    end

    if city.nil?
      user.city = "Ghost"
    else
      user.city = city
    end
    if promo.nil?
      user.promo = "NC"
    else
      user.promo = promo
    end

    return true
#    user.promo = "NC"
#    user.city = "NC"
  end

  def current_user
    #session[:user_email] = "florian.vuillemot@epitech.eu"
    puts session[:user_email]

    if session[:user_email]
      current_user = User.find_by_email(session[:user_email])
      if current_user.nil?
        redirect_to auth_login_path
        return
      end
    else
      redirect_to auth_login_path
      return
    end

    current_user = User.find_by_email(session[:user_email])
    if current_user.nil?
      current_user = User.new
      current_user.email = session[:user_email]
      current_user.admin = 0
      current_user.ranking = -1
      current_user.score = 0
      if get_user_data(current_user.email, current_user) === false
        render "auth/error"
        return
      end
      current_user.save
    end

    if session[:user_email]
      current_user = User.find_by_email(session[:user_email])
    else
      redirect_to auth_login_path
    end
  end

  def user_logged_in
    if session[:user_email] && session[:azure_token]
      return true
    else
      return false
    end
  end
end
