require 'net/http'
require 'json'

class AuthController < ApplicationController
  include AuthHelper

  def get_user_data(user_name, user)
    url = 'https://intra.epitech.eu/auth-ded102aa843dc494f2e69873c00fc05194d95a64/user/' + user_name +'/?format=json'
    '''
    uri = URI(url)

    res = Net::HTTP.get(uri)
    '''
    content = nil
    data = nil
    begin
      content = open(url).read
    rescue
      return false
    end
    
    if content.nil?
      return false
    end
    begin
      data = JSON.parse(content)
    rescue
      return false
    end
    if data.nil?
      return false
    end
    puts data

'''
    unless data["promo"] == 2020
      return false
    end


   url2 = "https://intra.epitech.eu/auth-ded102aa843dc494f2e69873c00fc05194d95a64/user/" + user_name +"/notes/?format=json"
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
   ''' 
    begin
      city = data["location"].split("/")[1]
      promo = data["promo"]
    rescue
      user.city = "NC"
      user.promo = "NC"
      return true
    end

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


  def gettoken
    token = get_token_from_code params[:code]
    session[:azure_token] = token.to_hash
    session[:user_email] = get_user_email token.token

    @user = User.find_by_email(session[:user_email])
    if @user.nil? # Never use
      @user = User.new
      @user.email = session[:user_email]
      @user.admin = 0
      @user.ranking = -1
      @user.score = 0
      if get_user_data(@user.email, @user) === false
        render 'auth/error'
        return
      end
      @user.save
    end
    redirect_to root_path
  end

  def login
  end

  def logout
    session[:azure_token] = nil
    session[:user_email] = nil
    redirect_to auth_login_path
  end

  def error
  end
end
