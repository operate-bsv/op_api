defmodule OpApi.Eventchain.Operate do
  require Logger
  alias OpApi.Ops
  alias OpApi.Ops.Op

  use OpApi.Eventchain.Handler, config: %{
    "eventchain" => 1,
    "name" => "Operate",
    "host" => %{ "bitbus" => "https://bob.bitbus.network" },
    "from" => 590000,
    "q" => %{
      "find" => %{
        "out.tape.cell" => %{
          "$elemMatch" => %{
            "i" => 0,
            "s" => "1PcsNYNzonE39gdZkvXEdt7TKBT5bXQoz4"
          }
        }
      }
    }
  }

  def onstart(e, _time) do
    if e.tape.self.start == nil do
      Logger.info "Eventchain: Starting from #{ e.head }"
      Ops.delete_all_ops
    else
      Logger.info "Eventchain: Starting from #{ e.tape.self.end }"
      Ops.delete_ops_from(e.tape.self.end)
    end
  end

  def onblock(txns, _time) do
    Logger.info "Eventchain: Inserting #{ Enum.count(txns) } ops"
    txns
    |> Enum.map(&Op.from_bob/1)
    |> Ops.insert_ops
  end

  def onmempool(tx, _time) do
    Logger.info "Eventchain: Inserting mempool op"
    Op.from_bob(tx)
    |> Ops.create_op
  end

end