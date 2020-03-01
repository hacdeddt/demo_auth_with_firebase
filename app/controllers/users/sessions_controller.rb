# frozen_string_literal: true
require 'rest-client'

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    RestClient.post(Settings.firebase.sign_in, { 'email' => params[:user][:email],
      'password': params[:user][:password], 'returnSecureToken': true }.to_json,
      { 'Content-Type' => 'application/json' }) { |response, request, result|
      case response.code
      when 301, 302, 307, 400
        error = JSON.parse(response)["error"]
        redirect_to new_user_session_path, alert: "Error #{error['code']}: #{error['message']}"
      when 200
        super
      end
    }
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
#   skip_before_action :require_login, only: %i[new create register_new register home]

#   def new
#     # user = login_firebase('phanvm.dba@gmail.com', '1234567890')
#     # user = sign_up('phanvm01@gmail.com', '1234567890')
#     # response = RestClient::Request.execute(method: :get, url: 'http://example.com/resource',
#     #                         timeout: 10)
#     render json: user
#   end

#   def sign_up(email, pass)
#     user = RestClient.post('https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyC0Z9INCUx-2uNXsufHox7oaOMjUuB6mI8
# ', { 'email' => email, 'password': pass, 'returnSecureToken': true }.to_json, { 'Content-Type' => 'application/json' })
#   end
#   # def firebase_login(token)
#   #   firebase_infos = firebase_verification(token)
#   #   render json: firebase_infos
#   # end
#   def login_firebase(email, pass)
#     url = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyC0Z9INCUx-2uNXsufHox7oaOMjUuB6mI8"
#     user = RestClient.post(url, { email: email, password: pass, 'returnSecureToken': true }.to_json, { 'Content-Type' => 'application/json' })
#   end

#   def firebase_verification(token)
#     url = "https://www.googleapis.com/identitytoolkit/v3/relyingparty/getAccountInfo?key=AIzaSyDz9hBUWTQesPIZBbTyzWy3DW2IwIpPbY0"
#     # firebase_verification_call = HTTParty.post(url, headers: { 'Content-Type' => 'application/json' }, body: { 'idToken' => token }.to_json )
#     firebase_verification_call = RestClient.post(url,  { 'idToken' => token }.to_json , { 'Content-Type' => 'application/json' })
#     # if firebase_verification_call.response.code == "200"
#     #   firebase_infos = firebase_verification_call.parsed_response
#     # else
#     #   raise CustomError
#     # end
#   end

#   def create
#     user = User.find_by_email(params[:email])
#     if user && user.authenticate(params[:password])
#       flash[:success] = 'Login success'
#       log_in user
#       redirect_to dashboard_path
#     else
#       flash[:danger] = 'Invalid email/password combination'
#       render :new
#     end
#   end
#   def destroy; end
#   def home
#     render :home
#   end
#   def register_new
#     @subscription = params[:subscription]
#     render :register
#   end
#   def register
#     @email = User.find_by({email: params[:user][:email]})
#     if @email
#       flash[:danger] = 'メールは既に存在します、あなたのメールアドレスを入力してください.'
#     else
#       @user = User.new(user_params_register)
#       if @user.save
#         flash[:sucsess] = '成功したユーザーを作成する.'
#         redirect_to '/'
#       else
#         flash[:danger] = 'ユーザーの作成に失敗しました.'
#         render :register
#       end
#     end
#   end
#     private
#   def user_params_register
#     params.require(:user).permit(:email, :password, :last_name, :first_name, :password_confirmation, :subscription)
#   end
end
