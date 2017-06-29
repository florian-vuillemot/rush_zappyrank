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
    data = JSON.parse(content)
    puts data

    city = data["location"].split("/")[1]
    promo = data["promo"]

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

#    user.promo = "NC"
#    user.city = "NC"
  end

  def current_user
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

    #session[:user_email] = "kevin.polossat@epitech.eu"
    current_user = User.find_by_email(session[:user_email])
    if current_user.nil?
      current_user = User.new
      current_user.email = session[:user_email]
      current_user.admin = 0
      current_user.ranking = -1
      current_user.score = 0
      get_user_data(current_user.email, current_user)
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
