class ApplicationController < ActionController::Base
  # before_action :configure_permitted_parameters , if: :devise_controller?
  
  # def configure_permitted_parameters
    # devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname, :avatar])
  # end

  # デフォルトでは「メールアドレス」と「パスワード」のみ許可されている。今回は「ユーザーネーム」などの追加で許可するパラメータがないので上記のアクションは不要。

end
