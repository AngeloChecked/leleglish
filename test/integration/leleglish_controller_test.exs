defmodule LeleglishWeb.LeleglishControllerTest do
  alias LeleglishWeb.LeleglishController, as: LeleglishController
  use ExUnit.Case

  test "get comments data" do 
    comments = LeleglishController.get_video_comments("43bXwdYeht4")

    assert %Leleglish.Comment{
        author_name: "Let Me Learn English", 
        author_profile_image_url: "https://yt3.ggpht.com/ytc/AKedOLQeaPJ_uHJFGYY-fsum7VkWxzl3wlh5L6WETHQCLEskvX_ORBIKSnL3wJ4Vi4K7=s48-c-k-c0x00ffffff-no-rj", 
        comment_url: "https://www.youtube.com/watch?v=43bXwdYeht4&lc=Ugyx95EAeGJPqydN2yd4AaABAg", 
        link: "https://www.youtube.com/watch?v=43bXwdYeht4&t=0m22s", 
        replays: [], 
        text: "!subject: grammatical error \n!description: \n'the time stamp where i committed' should be \"the time stamp when i committed\"", 
        time: "0:22"
      } in comments 
    assert %Leleglish.Comment{author_name: "Let Me Learn English", 
      author_profile_image_url: "https://yt3.ggpht.com/ytc/AKedOLQeaPJ_uHJFGYY-fsum7VkWxzl3wlh5L6WETHQCLEskvX_ORBIKSnL3wJ4Vi4K7=s48-c-k-c0x00ffffff-no-rj", 
      comment_url: "https://www.youtube.com/watch?v=43bXwdYeht4&lc=Ugw0uhb2Zoe9lhSQZOl4AaABAg", 
      link: "https://www.youtube.com/watch?v=43bXwdYeht4&t=0m55s", 
      replays: ["<a href=\"www.google.it\"> ciao </a>", "test test", "test xd", "test hahah"], 
      text: "are you too much fast to speak", 
      time: "0:55" } in comments 
  end
  
end
