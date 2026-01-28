PgReports.configure do |config|
  config.dashboard_auth = -> {
    next if Rails.env.development?
    next if ENV["JWT_KEY"] && session[:jwt_user_data]

    render plain: "Authentication required.", status: 401
  }
end
