defmodule RumblWeb.WatchView do
  use RumblWeb, :view

  def player_id(video) do
    ~r{^.*(?:youtu\.be/|\w+/|v=)(?<id>[^#&?]*)} #YouTube URLs come in a variety of formats. We need a regular expression to extract the video ID from the URL
    |> Regex.named_captures(video.url)
    |> get_in(["id"])
  end
end
