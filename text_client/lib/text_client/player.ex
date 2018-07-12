defmodule TextClient.Player do
  alias TextClient.{State, Summary, Prompter, Mover}

  # won, lost, good, guess, bad guess, already used, initalizing
  def play(game = %State{tally: %{ game_state: :won }}) do
    exit_message(game, "You won!")
  end

  def play(game = %State{tally: %{ game_state: :lost }}) do
    exit_message(game, "You lost")
  end

  def play(game = %State{tally: %{ game_state: :good_guess }}) do
    continue_message(game, "Good guess!")
  end

  def play(game = %State{tally: %{ game_state: :bad_guess }}) do
    continue_message(game, "Bad guess.")
  end

  def play(game = %State{tally: %{ game_state: :already_used }}) do
    continue_message(game, "You've already used that letter")
  end

  def play(game) do
    continue(game)
  end

  def continue(game) do
    game
    |> Summary.display
    |> Prompter.accept_move
    |> Mover.move
    |> play
  end

  defp continue_message(game, msg) do
    IO.puts msg
    continue(game)
  end

  defp exit_message(game = %State{tally: %{ solution: solution}}, msg) do
    IO.puts "#{msg}\nThe word is '#{solution}'"
    exit(:normal)
  end
end
