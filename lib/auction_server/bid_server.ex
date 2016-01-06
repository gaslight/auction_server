defmodule AuctionServer.BidServer do
  use GenServer

  alias AuctionServer.Repo
  alias AuctionServer.Bid

  # Client API

  def start_link(opts \\ []) do
    {:ok, pid} = GenServer.start_link(__MODULE__, [], opts)
  end

  def new_bid(bid_params) do
    GenServer.call(:bid_server, {:new_bid, bid_params})
  end

  # Server implementation

  def init([]) do
    bids = Repo.all(Bid)
    {:ok, bids}
  end

  def handle_call({:new_bid, bid_params}, _from, bids) do
    changeset = Bid.changeset(%Bid{}, bid_params)
    case Repo.insert(changeset) do
      {:ok, bid} ->
        Auctioneer.Endpoint.broadcast! "bids:max", "change", Auctioneer.BidView.render("show.json", %{bid: bid})
        {:reply, {:ok, bid}, [bid | bids]}
      {:error, changeset} ->
        {:reply, {:error, changeset}, bids}
    end
  end

end
