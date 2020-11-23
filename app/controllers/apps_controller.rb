class AppsController < ApplicationController
  def index
    apps =
      if params[:os] == 'android'
        Rpush::Gcm::App.where(name: current_app.app_name).order(
          updated_at: :desc
        )
      elsif params[:os] == 'ios'
        if current_app.apnsp8?
          Rpush::Apnsp8::App.where(name: current_app.app_name).order(
            updated_at: :desc
          )
        else
          Rpush::Apns::App.where(name: current_app.app_name).order(
            updated_at: :desc
          )
        end
      else
        []
      end
    render json: {
             apps: apps.as_json(only: %i[id name updated_at environment]),
             apns_version: current_app.apns_version
           }
  end

  def create
    app =
      if app_params[:os] == 'android'
        app = Rpush::Gcm::App.new
        app.name = current_app.app_name
        app.auth_key = app_params[:auth_key]
        app.connections = app_params[:connections] || 1
        app
      elsif app_params[:os] == 'ios'
        if current_app.apnsp8?
          app = Rpush::Apnsp8::App.new
          app.name = current_app.app_name
          app.apn_key = app_params[:apn_key]
          app.apn_key_id = app_params[:apn_key_id]
          app.team_id = app_params[:team_id]
          app.bundle_id = app_params[:bundle_id]
          app.environment = 'development'
          app.connections = app_params[:connections] || 1
          app
        else
          app = Rpush::Apns::App.new
          app.name = current_app.app_name
          app.certificate = app_params[:certificate]
          app.environment = app_params[:environment]
          app.password = app_params[:password]
          app.connections = app_params[:connections] || 1
          app
        end
      else
        nil
      end
    if app.present?
      if app.save
        render json: {}, status: 201
      else
        render json: { errors: app.errors.full_messages }, status: 400
      end
    else
      render json: {
               errors: ['Please, specify type os of an app - "ios/android"']
             },
             status: 400
    end
  end

  def destroy
    app =
      if params[:os] == 'android'
        Rpush::Gcm::App.find_by!(id: params[:id], name: current_app.app_name)
      elsif params[:os] == 'ios'
        if current_app.apnsp8?
          Rpush::Apnsp8::App.find_by!(
            id: params[:id], name: current_app.app_name
          )
        else
          Rpush::Apns::App.find_by!(id: params[:id], name: current_app.app_name)
        end
      end
    if app.destroy
      render json: {}
    else
      render json: { errors: app.errors.full_messages }, status: 400
    end
  end

  def change_apns
    if current_app.update(apns_version: params[:apns_version])
      render json: {}, status: 200
    else
      render json: { errors: change_apns_apps_url.errors.full_messages },
             status: 400
    end
  end

  private

  def app_params
    params.require(:app).permit(
      :id,
      :certificate,
      :environment,
      :password,
      :connections,
      :os,
      :auth_key,
      :apn_key,
      :apn_key_id,
      :team_id,
      :bundle_id
    )
  end
end
