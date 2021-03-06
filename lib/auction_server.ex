defmodule AuctionServer do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Define workers and child supervisors to be supervised
      # worker(AuctionServer.Worker, [arg1, arg2, arg3])
      worker(AuctionServer.Repo, []),
      worker(AuctionServer.BidServer, [[name: :bid_server]])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: :auction_server_supervisor]
    Supervisor.start_link(children, opts)
  end
end
