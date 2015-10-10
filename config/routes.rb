module Example
  class App < Sinatra::Base
    configure do
      # Asset configuration and settings
      set root: File.expand_path('../../', __FILE__)
      register Sinatra::AssetPipeline
      set :assets_css_compressor, :sass
      set :assets_js_compressor, :uglifier
      if defined?(RailsAssets)
        RailsAssets.load_paths.each do |path|
          settings.sprockets.append_path(path)
        end
      end
    end

    get '/' do
      ensure_authenticated
      @user = user
      @warden = env['warden']
      haml :demo_index
    end

    get '/no_authentication' do
      haml :demo_index
    end

    get '/redirect_to' do
      ensure_authenticated
      "Hello There, #{user.name}! return_to is working!"
    end

    # This is where the app redirects after authenticating with the OAuth provider
    # Probably don't change it
    get "/auth/oauthed/callback" do
      ensure_authenticated
      redirect '/'
    end

    # You may not need this
    get '/logout' do
      env['warden'].logout
      "Peace!"
    end
  end
end