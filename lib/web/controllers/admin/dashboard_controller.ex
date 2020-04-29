defmodule Web.Admin.DashboardController do
  use Web, :controller

  def index(conn, _params) do
    # See if their current certification record is expiring soon, offer to let them request a new certification
    # user Account.active_certification_for_user(user) to see when their current one expires
    %{current_user: user} = conn.assigns
    # redirect(conn, to: Routes.admin_challenge_path(conn, :index))
    conn
    |> assign(:user, user)
    |> assign(:filter, nil)
    |> assign(:sortgh6, nil)
    |> render("index.html")
  end
end
