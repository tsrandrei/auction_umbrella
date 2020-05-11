defmodule Auction.Item do
  # defstruct [:id, :title, :description, :ends_at]
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :title, :string
    field :description, :string
    field :ends_at, :utc_datetime
    has_many :bids, Auction.Bid
    timestamps()
  end

  def changeset(item, params \\ %{}) do
    item
    |> cast(params, [:title, :description, :ends_at])
    |> validate_required(:title, message: "Title is baaad")
    |> validate_required(:description, message: "Description is baaad")
    |> validate_length(:title, min: 3, message: "Title must be at least 3 characthers")
    |> validate_length(:description, max: 200, message: "Description must be under 200 chars")
    |> validate_length(:title, min: 3, message: "Title must be at least 3 characthers")
    |> validate_change(:ends_at, &validate/2)
  end

  defp validate(:ends_at, ends_at_date) do
    case DateTime.compare(ends_at_date, DateTime.utc_now()) do
      :lt -> [ends_at: "ends_at cannot be in the past"]
        _ -> []
    end
  end
end
