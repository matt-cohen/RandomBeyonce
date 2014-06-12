require 'sinatra'
require 'sinatra/reloader'

configure do
    enable :sessions
end

# def list_of_videos()
#     youtube = ['<iframe width="1280" height="720" src="//www.youtube.com/embed/2EwViQxSJJQ" frameborder="0" allowfullscreen></iframe>', '<iframe width="1280" height="720" src="//www.youtube.com/embed/bnVUHWCynig" frameborder="0" allowfullscreen></iframe>', '<iframe width="1280" height="720" src="//www.youtube.com/embed/AWpsOqh8q0M" frameborder="0" allowfullscreen></iframe>', '<iframe width="1280" height="720" src="//www.youtube.com/embed/LXXQLa-5n5w" frameborder="0" allowfullscreen></iframe>', '<iframe width="1280" height="720" src="//www.youtube.com/embed/p1JPKLa-Ofc" frameborder="0" allowfullscreen></iframe>']
#     return youtube[rand(youtube.length)]
# end

# sets = Hash.new

# def list_sets()
  
# end

def list_sets()
    session[:list].each do |set|
        return set
    end
end

get '/' do
    session[:list] ||= {} 
    erb :index
end

get '/sets' do
    list_sets()
    erb :sets, :locals => {:list => session[:list]}
end

get '/sets/:setname/play' do
    name = params[:setname]

    array = session[:list][params[:setname]]["vidnums"]
    @rest_of_vids = ''
    session[:list][params[:setname]]["vidnums"].each do |vidnum|
        if vidnum == session[:list][params[:setname]]["vidnums"][0]
            @first_vid = vidnum
        elsif vidnum != session[:list][params[:setname]]["vidnums"][session[:list][params[:setname]]["vidnums"].length-1]
            @rest_of_vids << vidnum + ','
        else
            @rest_of_vids << vidnum
        end
    end

    first = @first_vid
    rest = @rest_of_vids

    vid_playlist = '<iframe width="560" height="315" src="https://www.youtube.com/v/' + @first_vid + '?version=3&loop=1&playlist=' + @rest_of_vids + '" frameborder="0" allowfullscreen></iframe>'


    #"<iframe width="560" height="315" src="https://www.youtube.com/v/first_vid.to_s?version=3&loop=1&playlist=rest_of_vids.to_s" frameborder="0" allowfullscreen></iframe>"
# http://sitename.com/beyoncehits/play
# http://sitename.com/summerbeyonce/play
# http://sitename.com/winterbeyonce/play
# http://sitename.com/2/play

# ^ all of these map into this handler.  Based upon the set requested,
# return the video player template with the correct video url's.


    erb :display, :locals => {:name => name, :vid_playlist => vid_playlist, :first => first, :rest => rest}
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

# get '/sets/beyonce' do
#     set_name = params[:name]
#     session[:list][]
#     erb :display, :locals => {:set_name => set_name, :set_videos => set_videos}
# end

get '/sets/beyonce/play' do
   current_video_list = session[:list][params[:button]]

   erb :display
end

get '/sets/beyonce/edit' do
    #return an HTML form for editing a set
end

put '/sets/beyonce' do
    #update a specific set
end

delete '/sets/beyonce' do
    #delete a specific set
end
