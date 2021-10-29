defmodule Leleglish.YoutubeClient.Comment do
  defstruct id: "", comment_url: "", author_name: "", author_profile_image_url: "", text: "", html: "", replays: [] 

  @type t :: %__MODULE__{
          id: String.t,
          comment_url: String.t,
          author_name: String.t,
          author_profile_image_url: String.t, 
          text: String.t,
          html: String.t,
          replays: list(String.t)
  }
end

defmodule Leleglish.YoutubeClient do
  require Logger
  use HTTPoison.Base

  def call(:replays, video_id, parent_id), do: call(replays_url(video_id, parent_id))
  def call(:top_level_comments, video_id), do: call(url(video_id))
  def call(url) do
    headers = ["Accept": "application/json"]
    response = HTTPoison.get(url, headers)
    case response do
      {:ok, res} -> res
      {:error, error} -> Logger.error "error >>>>>: #{inspect(error)}"
    end
  end

  def replays_url(video_id, parent_id) do 
    api_key = System.get_env("GOOGLE_API_KEY")
    "https://www.googleapis.com/youtube/v3/comments"
    |> URI.parse()
    |> Map.put(:query, URI.encode_query(
      part: "snippet", 
      parentId: parent_id,
      videoId: video_id,
      key: api_key 
    ))
    |> URI.to_string()
  end

  def url(video_id) do
    #api_key = System.get_env("GOOGLE_API_KEY")
    api_key = Application.fetch_env!(:env, :GOOGLE_API_KEY)
    "https://www.googleapis.com/youtube/v3/commentThreads"
    |> URI.parse()
    |> Map.put(:query, URI.encode_query(
      part: "id,snippet", 
      videoId: video_id,
      key: api_key 
    ))
    |> URI.to_string()
  end

  defp retrieve_replay_for(video_id, parent_id) do
    %HTTPoison.Response{body: body} = call(:replays, video_id, parent_id) 
    %{ "items" => items } = body |> Poison.decode!
    Enum.map(items, fn item -> item["snippet"]["textOriginal"] end) 
  end

  def response_to_comments(%HTTPoison.Response{body: body}) do
    %{ "items" => items } = body |> Poison.decode!
    comments = Enum.map(items, fn item -> 
        comment_id = item["id"]
        video_id = item["snippet"]["videoId"] 
        replays = retrieve_replay_for(video_id, comment_id)
        %Leleglish.YoutubeClient.Comment{
          id: comment_id, 
          comment_url: "https://www.youtube.com/watch?v=#{video_id}&lc=#{comment_id}",
          author_name: item["snippet"]["topLevelComment"]["snippet"]["authorDisplayName"],
          author_profile_image_url: item["snippet"]["topLevelComment"]["snippet"]["authorProfileImageUrl"],
          text: item["snippet"]["topLevelComment"]["snippet"]["textOriginal"],
          html: item["snippet"]["topLevelComment"]["snippet"]["textDisplay"],
          replays: replays
        } 
      end
    ) 
    comments
  end
end
