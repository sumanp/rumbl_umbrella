defmodule Rumbl.TestHelpers do
  alias Rumbl.{
    Accounts,
    Multimedia
  }

  def user_fixture(attrs \\ %{}) do #accepts a map of attributes
    {:ok, user} =
      attrs
      |> Enum.into(%{
        name: "Some User",
        username: "user#{System.unique_integer([:positive])}",
        password: attrs[:password] || "supersecret"
      })
      |> Accounts.register_user()

    user
  end

  def video_fixture(%Accounts.User{} = user, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        title: "A Title",
        url: "http://example.com",
        description: "a description"
      })

    {:ok, video} = Multimedia.create_video(user, attrs)

    video
  end
end

# Notice that the functions in those two files are extremely thin. 
# They simply integrate with the context features we’ve already written.
# Such thin functions don’t necessarily mean that your design is right,
# but it is a data point.
