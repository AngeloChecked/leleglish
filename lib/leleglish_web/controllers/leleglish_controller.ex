defmodule LeleglishWeb.LeleglishController do
  require Logger
  use LeleglishWeb, :controller
  alias Leleglish.YoutubeCommentsMapper, as: YoutubeCommentsMapper
  alias Leleglish.YoutubeClient, as: YoutubeClient

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def get_video_comments(video_id) do
    comments = YoutubeClient.call(:top_level_comments, video_id) 
      |> YoutubeClient.response_to_comments()
      |> Enum.flat_map(&YoutubeCommentsMapper.map/1)
      |> Enum.sort(&YoutubeCommentsMapper.compare_timer_ascending/2)
    comments
  end
end
