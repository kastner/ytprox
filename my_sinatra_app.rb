class MySinatraApp < Sinatra::Base
  get "/" do
    "Hello Bundler"
  end

  get "/:video_id/:start/:end" do
    start_s  = ChronicDuration::parse(params[:start])
    end_s    = ChronicDuration::parse(params[:end])
    duration = end_s - start_s


    unless File.exists?(cache_path(params[:video_id]))
      # need to download
      
      `youtube-dl -o #{cache_path(params[:video_id])} -f worstaudio #{params[:video_id]}`
    end

    # set content type header
    content_type 'audio/aac'
    #puts "ffmpeg -ss #{start_s} -i #{cache_path(params[:video_id])} -vn -c copy -t #{duration} -"
    `ffmpeg -ss #{start_s} -i #{cache_path(params[:video_id])} -vn -c copy -t #{duration} -f adts -`
  end
end


def cache_path(fragment)
  "cache/#{fragment}.aac"
end
