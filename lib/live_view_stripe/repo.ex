defmodule LiveViewStripe.Repo do
  use Ecto.Repo,
    otp_app: :live_view_stripe,
    adapter: Ecto.Adapters.Postgres
end
