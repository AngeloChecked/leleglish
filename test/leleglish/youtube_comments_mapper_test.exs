defmodule Leleglish.YoutubeCommentsMapperTest do
  use ExUnit.Case
  alias Leleglish.YoutubeCommentsMapper, as: YoutubeCommentsMapper
  alias Leleglish.YoutubeClient, as: YoutubeClient
  doctest Leleglish.YoutubeCommentsMapper

  test "map" do
    comments = YoutubeCommentsMapper.map(%YoutubeClient.Comment{
        comment_url: "https://", 
        author_name: "mario",
        author_profile_image_url: "https://", 
        text: "no 00:22 dfajdfk asdl 0:12 jfafjsdkfks wejfal  112:33 sdfjkasdfkkfcicaio", 
        html: """ 
        <a href=\"https://www.youtube.com/watch?v=43bXwdYeht4&amp;t=0m22s\">0:22</a> df
        <a href=\"https://www.youtube.com/watch?v=43bXwdYeht4&amp;t=0m12s\">0:12</a> jf
        <a href=\"https://www.youtube.com/watch?v=43bXwdYeht4&amp;t=112m33s\">112:33</a> sd
        """, 
        replays: []
      }
    )

    assert comments == [
      %Leleglish.Comment{
        comment_url: "https://", 
        author_name: "mario",
        author_profile_image_url: "https://", 
        link: "https://www.youtube.com/watch?v=43bXwdYeht4&t=0m22s", 
        text: "dfajdfk asdl", time: "0:22"}, 
      %Leleglish.Comment{
        comment_url: "https://", 
        author_name: "mario",
        author_profile_image_url: "https://", 
        link: "https://www.youtube.com/watch?v=43bXwdYeht4&t=0m12s", 
        text: "jfafjsdkfks wejfal", time: "0:12"}, 
      %Leleglish.Comment{
        comment_url: "https://", 
        author_name: "mario",
        author_profile_image_url: "https://", 
        link: "https://www.youtube.com/watch?v=43bXwdYeht4&t=112m33s", 
        text: "sdfjkasdfkkfcicaio", time: "112:33"}
    ]
  end

  test "text without timestamp should be ignored" do
    comments = YoutubeCommentsMapper.map(%YoutubeClient.Comment{
        comment_url: "https://", 
        author_name: "mario",
        author_profile_image_url: "https://", 
        text: "text without timestamp", 
        html: "text without timestamp", 
        replays: []
      }
    )

    assert comments == []
  end

  test "compare timer" do
    assert YoutubeCommentsMapper.compare_timer_ascending(%{time: "12:11"},%{time: "12:15"}) == true
    assert YoutubeCommentsMapper.compare_timer_ascending(%{time: "12:15"},%{time: "12:15"}) == true
    assert YoutubeCommentsMapper.compare_timer_ascending(%{time: "12:16"},%{time: "12:15"}) == false 
    assert YoutubeCommentsMapper.compare_timer_ascending(%{time: "11:16"},%{time: "12:15"}) == true 
    assert YoutubeCommentsMapper.compare_timer_ascending(%{time: "13:16"},%{time: "12:15"}) == false 
  end
end
