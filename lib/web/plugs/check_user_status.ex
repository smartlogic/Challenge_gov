defmodule Web.Plugs.CheckUserStatus do
  @moduledoc """
  Verify a user is active
  """

  import Plug.Conn
  import Phoenix.Controller

  alias Web.Router.Helpers, as: Routes

  def init(default), do: default

  def call(conn, _opts) do
    with {:ok, user} <- Map.fetch(conn.assigns, :current_user) do
      case user.status do
        "pending" ->
          conn
          |> redirect(to: Routes.admin_terms_path(conn, :pending))
          |> halt()

        # Many of these need to change so that the user can come in and be told how to try and regain access

        "suspended" ->
          conn
          |> clear_flash()
          |> put_flash(:error, "Your account has been suspended")
          |> clear_session()
          |> redirect(to: Routes.session_path(conn, :new))
          |> halt()

        "revoked" ->
          conn
          |> clear_flash()
          |> put_flash(:error, "Your account has been revoked")
          |> clear_session()
          |> redirect(to: Routes.session_path(conn, :new))
          |> halt()

        "deactivated" ->
          conn
          |> clear_flash()
          |> put_flash(:error, "Your account has been deactivated")
          |> clear_session()
          |> redirect(to: Routes.session_path(conn, :new))
          |> halt()

        # For decertified, they would request a new certification which will make a pending review certification record in the database
        # This is a record with their id, and the requested_on, but no approver, activate on, and no expires on.

        "decertified" ->
          conn
          |> clear_flash()
          |> put_flash(:error, "Your account has been decertified")
          |> clear_session()
          |> redirect(to: Routes.session_path(conn, :new))
          |> halt()

        "active" ->
          conn

        _ ->
          conn
          |> clear_flash()
          |> put_flash(:error, "Your account has an unknown error")
          |> clear_session()
          |> redirect(to: Routes.session_path(conn, :new))
          |> halt()
      end
    else
      _ ->
        conn
        |> clear_flash()
        |> put_flash(:error, "Your account has an unknown error")
        |> clear_session()
        |> redirect(to: Routes.session_path(conn, :new))
        |> halt()
    end
  end
end
