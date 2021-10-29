defmodule Leleglish.YoutubeClientTest do
  use ExUnit.Case
  alias Leleglish.YoutubeClient, as: YoutubeClient
  doctest Leleglish.YoutubeClient 

  test "api work" do
    %HTTPoison.Response{body: body} = YoutubeClient.call(:top_level_comments, "43bXwdYeht4") 
    %{ "items" => [ %{"snippet" => snippet} | _tail ] } = body |> Poison.decode!
    %{ "topLevelComment" => %{ "snippet" => %{ "textDisplay" => first_comment } } } = snippet

    assert first_comment != "" 
  end

  test "url" do
    api_key=System.get_env("GOOGLE_API_KEY")
    assert YoutubeClient.url("43bXwdYeht4") == "https://www.googleapis.com/youtube/v3/commentThreads?" <>
      "part=id%2Csnippet&videoId=43bXwdYeht4&key=#{api_key}"
  end

  test "top level comments" do
    comments = YoutubeClient.call(:top_level_comments, "43bXwdYeht4") 
      |> YoutubeClient.response_to_comments()

    last = length(comments)-1
    %{html: plast_comment} = Enum.fetch!(comments, last-1)
    %{html: last_comment} = Enum.fetch!(comments, last)
    
    assert String.contains?(plast_comment, "much fast")
    assert String.contains?(last_comment, "grammatical error")
  end

  test "replays call" do
    %HTTPoison.Response{body: body} = YoutubeClient.call(:replays, "43bXwdYeht4", "Ugw0uhb2Zoe9lhSQZOl4AaABAg")  
    %{ "items" =>[ %{"snippet" => snippet} | _tail ] } = body |> Poison.decode!
    %{ "textDisplay" => first_replay } = snippet

    assert String.contains?(first_replay, "google") 
  end


  test "replays" do
    comments = YoutubeClient.call(:top_level_comments, "43bXwdYeht4") 
      |> YoutubeClient.response_to_comments()

    last = length(comments)-1
    %{replays: plast} = Enum.fetch!(comments, last-1)
    %{replays: last} = Enum.fetch!(comments, last)

    assert plast == ["<a href=\"www.google.it\"> ciao </a>", "test test", "test xd", "test hahah"] 
    assert last == [] 
  end

  test "author data" do
    comments = YoutubeClient.call(:top_level_comments,"43bXwdYeht4") 
      |> YoutubeClient.response_to_comments()

    last = length(comments)-1
    %{author_name: author_name, author_profile_image_url: image_url, comment_url: comment_url} = Enum.fetch!(comments, last-1)

    assert author_name == "Let Me Learn English" 
    assert comment_url == "https://www.youtube.com/watch?v=43bXwdYeht4&lc=Ugw0uhb2Zoe9lhSQZOl4AaABAg" 
    assert image_url == "https://yt3.ggpht.com/ytc/AKedOLQeaPJ_uHJFGYY-fsum7VkWxzl3wlh5L6WETHQCLEskvX_ORBIKSnL3wJ4Vi4K7=s48-c-k-c0x00ffffff-no-rj"
  end

end
