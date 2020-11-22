require Rails.root.join('lib/rails_admin/config/fields/types/citext')

RailsAdmin.config do |config|
  config.authorize_with do
    authenticate_or_request_with_http_basic(
      'Basic authorization'
    ) do |username, password|
      username == ENV.fetch('ADMIN_USERNAME') { 'admin' } &&
        password == ENV.fetch('ADMIN_PASSWORD') { 'admin' }
    end
  end

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard # mandatory
    index # mandatory
    new { except %w[MobileUser MobileDevice] }
    export
    bulk_delete
    show
    edit { except %w[MobileUser MobileDevice] }
    delete { except %w[MobileUser MobileDevice] }
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.model 'MobileAccess' do
    edit do
      field :email
      field :app_name do
        visible { bindings[:object].id.blank? }
      end
      field :client_token do
        visible { bindings[:object].id.present? }
      end
      field :server_token do
        visible { bindings[:object].id.present? }
      end
    end
    list do
      field :app_name
      field :email
      field :client_token
      field :server_token
      field :updated_at
    end
  end

  config.model 'MobileDevice' do
    list do
      field :device_type
      field :device_token
      field :mobile_user
      field :updated_at
    end
  end

  config.model 'MobileUser' do
    list do
      field :external_key
      field :environment
      field :mobile_access
      field :mobile_devices
      field :updated_at
    end
  end
end
