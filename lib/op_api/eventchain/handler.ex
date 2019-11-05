defmodule OpApi.Eventchain.Handler do
  require Logger

  defmacro __using__(options \\ []) do
    {config, _} = Keyword.get(options, :config, %{})
    |> Macro.escape
    |> Code.eval_quoted

    quote do
      def config, do: unquote(config)

      def parse_message(<<"ONSTART ", message::binary>>) do
        Logger.info "Eventchain: ONSTART received"
        [timestamp, event] = String.split(message, ~r/\s+/, parts: 2, trim: true)
        apply(__MODULE__, :onstart, decode_elements(event, timestamp))
      end

      def parse_message(<<"ONBLOCK ", message::binary>>) do
        Logger.info "Eventchain: ONBLOCK received"
        [timestamp, _blk, event] = String.split(message, ~r/\s+/, parts: 3, trim: true)
        apply(__MODULE__, :onblock, decode_elements(event, timestamp))
      end

      def parse_message(<<"ONMEMPOOL ", message::binary>>) do
        Logger.info "Eventchain: ONMEMPOOL received"
        [timestamp, _txid, event] = String.split(message, ~r/\s+/, parts: 3, trim: true)
        apply(__MODULE__, :onmempool, decode_elements(event, timestamp))
      end

      def parse_message(_message), do: nil # Ignore all other messages

      defp decode_elements(event, timestamp) do
        [
          Jason.decode!(event, keys: :atoms),
          String.to_integer(timestamp) |> DateTime.from_unix!(:microsecond)
        ]
      end
    end
  end

end