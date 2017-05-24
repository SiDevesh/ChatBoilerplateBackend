defmodule EopChatBackend.Plugs.EmailVerified do
  import Plug.Conn

  def init(opts) do
    opts = Enum.into(opts, %{})
    handler = build_handler_tuple(opts)

    rem_of_ops = Map.drop(opts, [:handler])
    Map.merge(rem_of_ops, %{handler: handler})
  end

  def call(conn, opts) do
    case Guardian.Plug.claims(conn) do
      {:ok, claims} -> conn |> check_email_verified(opts, claims)
      {:error, reason} -> handle_error(conn, {:error, reason}, opts)
    end
  end

  defp check_email_verified(conn, opts, claims) do
    if claims["email_verified"] do
      conn
    else
      handle_error(conn, {:error, :email_not_verified}, opts)
    end
  end

  defp handle_error(%Plug.Conn{params: params} = conn, reason, opts) do
    conn = conn |> assign(:guardian_failure, reason)# |> halt
    params = Map.merge(params, %{reason: reason})
    {mod, meth} = Map.get(opts, :handler)
    apply(mod, meth, [conn, params])
  end

  defp build_handler_tuple(%{handler: mod}) do
    {mod, :email_not_verified}
  end
  defp build_handler_tuple(_) do
    {EopChatBackend.GuardianErrorHandler, :email_not_verified}
  end

end