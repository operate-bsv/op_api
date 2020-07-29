defmodule OpApi.Scraper do
  require Logger
  alias OpApi.Ops
  alias OpApi.Ops.Op
  alias OpApi.Settings


  @query %{
    "find" => %{
      "out.tape.cell" => %{
        "$elemMatch" => %{
          "i" => 0,
          "s" => "1PcsNYNzonE39gdZkvXEdt7TKBT5bXQoz4"
        }
      }
    }
  }


  use Terminus.Planaria, token: {:op_api, :planaria_token},
                         from: 590000,
                         host: :bob,
                         query: @query


  def handle_tape(:start, tape) do
    tape = case Settings.get("head") do
      nil ->
        Ops.delete_all_ops
        tape
      head ->
        head = String.to_integer(head)
        Ops.delete_ops_from(head)
        put_in(tape.head, head)
    end

    {:ok, tape}
  end


  def handle_tape(:update, tape) do
    Settings.set("head", tape.head)
    {:ok, tape}
  end


  def handle_data(:block, txns) do
    Logger.info "Block: Inserting #{ Enum.count(txns) } ops"
    txns
    |> Enum.map(&Terminus.BitFS.scan_tx/1)
    |> Enum.map(&Op.from_bob/1)
    |> Ops.insert_ops
  end


  def handle_data(:mempool, txns) do
    Logger.info "Mempool: Inserting #{ Enum.count(txns) } ops"
    txns
    |> Enum.map(&Terminus.BitFS.scan_tx/1)
    |> Enum.map(&Op.from_bob/1)
    |> Ops.insert_ops
  end

end
