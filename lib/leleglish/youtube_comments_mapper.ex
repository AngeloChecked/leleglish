defmodule Leleglish.Comment do
   defstruct text: "", time: "", link: "", comment_url: "", author_name: "", author_profile_image_url: "", replays: [] 
end

defmodule Leleglish.YoutubeCommentsMapper do

  alias Leleglish.YoutubeClient, as: YoutubeClient

  def map(
    %YoutubeClient.Comment{
      comment_url: comment_url, 
      author_name: author_name,
      author_profile_image_url: author_profile_image_url, 
      text: text, html: html, replays: replays}
  ) do
    [_ | textComments ] = String.split(text, ~r/[0-9]?[0-9]?[0-9]:[0-9]?[0-9]/)

    {:ok, document} = Floki.parse_document(html)
    comments = Enum.map(Floki.find(document, "a"), fn element ->
    { _, [{_, link}], [time] } = element 
    %Leleglish.Comment{time: time, link: link}
    end)
    comments = Enum.zip_with([textComments, comments], fn [textComment, comment] -> 
      %{time: time, link: link} = comment
      %Leleglish.Comment{
        text: String.trim(textComment), time: time, link: link, 
        comment_url: comment_url, 
        author_name: author_name,
        author_profile_image_url: author_profile_image_url, 
        replays: replays
      }
    end)
  end

  def compare_timer_ascending(%{time: f}, %{time: s}) do
    [minute_first, seconds_first] = String.split(f, ":") 
    [minute_second, seconds_second] = String.split(s, ":") 
    cond do 
      minute_first == minute_second -> seconds_first <= seconds_second 
      true -> minute_first < minute_second 
    end
  end

end
