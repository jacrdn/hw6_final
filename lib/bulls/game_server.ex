defmodule Bulls.GameServer do
  use GenServer

  alias Bulls.BackupAgent
  alias Bulls.Game

  # public interface

  def reg(name) do
    {:via, Registry, {Bulls.GameReg, name}}
  end

  def start(name) do
    spec = %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [name]},
      restart: :permanent,
      type: :worker
    }
    Bulls.GameSup.start_child(spec)
  end

  def start_link(name) do
    game = BackupAgent.get(name) || Game.new
    GenServer.start_link(
      __MODULE__,
      game,
      name: reg(name)
    )
  end

  def reset(name) do
    GenServer.call(reg(name), {:reset, name})
  end

  def guess(name, letter) do
    GenServer.call(reg(name), {:guess, name, letter})
  end


  def setUn(name, un) do
    GenServer.call(reg(name), {:setUn, name, un})
  end

  def peek(name) do
    GenServer.call(reg(name), {:peek, name})
  end

  # implementation

  def init(game) do
    Process.send_after(self(), :pook, 10_000)
    {:ok, game}
  end

  def handle_call({:reset, name}, _from, game) do
    game = Game.new
    BackupAgent.put(name, game)
    {:reply, game, game}
  end

  def handle_call({:guess, name, letter}, _from, game) do
    game = Game.guess(game, letter)
    BackupAgent.put(name, game)
    {:reply, game, game}
  end

  def handle_call({:setUn, name, un}, _from, game) do
    game = Game.setUn(game, un)
    BackupAgent.put(name, game)
    {:reply, game, game}
  end

  def handle_call({:peek, _name}, _from, game) do
    {:reply, game, game}
  end

  def handle_info(:pook, game) do
    BullsWeb.Endpoint.broadcast!(
      game.name,
      "view",
      Game.view(game, game.name))
    {:noreply, game}
  end
end
