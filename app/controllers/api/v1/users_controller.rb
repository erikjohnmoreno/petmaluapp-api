class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user, except: [:create, :index, :login]

  def index
    @users = User.all
    render json: @users
  end

  def create
    context = { success: false }

    @user = User.new({
      email: params['email'],
      password: params['password'],
      password_confirmation: params['password_confirmation']})

    if @user.save
      context['success'] = true
      context['status'] = 'success'
      context['message'] = "Congrats! you successfully signup to malupet na app!"
      render json: context
    else
      context['status'] = 'danger'
      render json: context
    end

  end

  def login
    context = { success: false }

    email = params['email']
    password = params['password']

    @user = User.find_by email: email

    if @user
      if @user.valid_password?(password)
        context['status'] = 'success'
        context['success'] = true
        context['message'] = "Successfully signed in as #{@user.email}"
        context['token'] = @user.token
        render json: context
      else
        context['status'] = 'error'
        context['message'] = 'login error'
        render json: context
      end
    else
      context['status'] = 'error'
      context['message'] = 'login error'
      render json: context
    end
  end

end
