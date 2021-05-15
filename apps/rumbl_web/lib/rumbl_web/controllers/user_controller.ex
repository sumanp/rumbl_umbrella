defmodule RumblWeb.UserController do
  use RumblWeb, :controller # decalre use of controller API

  alias Rumbl.Accounts
  alias Rumbl.Accounts.User

  plug :authenticate_user when action in [:index, :show] # before_action with function plug

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Accounts.change_registration(%User{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def show(conn, %{"id" => id}) do
    # Now, you can see why Plug breaks out the params part of the inbound conn.
    # We can use params to extract the individual elements our action needs
    user = Accounts.get_user(id)
    render(conn, "show.html", user: user)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} -> conn
        |> RumblWeb.Auth.login(user)
        |> put_flash(:info, "#{user.name} created!")
        |> redirect(to: Routes.user_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  # This pattern of code should be getting familiar to you by now.
  # We keep piping functions together until the conn has the final result that we want.
  # Each function does an isolated transform step.
end
