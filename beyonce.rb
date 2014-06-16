require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'rubocop'

use Rack::MethodOverride

configure do
    enable :sessions
end

get '/' do
    session[:list] ||= {} 
    erb :index
end

get '/sets' do
    erb :sets, :locals => {:list => session[:list]}
end

get '/sets/:setname/play' do
    name = params[:setname]

    array = session[:list][params[:setname]]["vidnums"]  
    @rest_of_vids = ''
   array.each do |vidnum|
        if vidnum == array[0]
            @first_vid = vidnum
        elsif vidnum != array[array.length-1]
            @rest_of_vids << vidnum + ','
        else
            @rest_of_vids << vidnum
        end
    end

    first = @first_vid
    rest = @rest_of_vids

    vid_playlist = '<iframe width="750" height="500" src="https://www.youtube.com/v/' + @first_vid + '?version=3&loop=1&playlist=' + @rest_of_vids + '" frameborder="0" allowfullscreen></iframe>'

    erb :display, :locals => {:name => name, :vid_playlist => vid_playlist, :first => first, :rest => rest}
end

get '/sets/:setname/edit' do
    name = params[:setname]
    # binding.pry
    erb :edit, :locals => {:set => session[:list][name]}
end

get '/sets/new' do
    erb :new
end

post '/sets' do
    videos = params[:vidnums]
    videos = videos.split("\r\n")
    session[:list][params[:name]] = {"name" => params[:name], "vidnums" => videos, "description" => params[:description]}
    erb :sets, :locals => {:list => session[:list]}
end

get '/sets/:name' do
    name = params[:name]
    session[:list].delete(name)
    redirect to('/sets')
    erb :display, :locals => {:list => session[:list]}
end

put '/sets' do
	name = params[:name]
	videos = params[:vidnums]
    videos = videos.split("\r\n")
    session[:list][params[:name]] = {"name" => params[:name], "vidnums" => videos, "description" => params[:description]}
    erb :sets, :locals => {:list => session[:list]}
end


