defmodule TextClient.Summary do

  def display(game = %{ game_state: :won, tally: tally }) do
    IO.puts [
      """
      Yes the word was #{Enum.join(tally.letters, "")}
      You won!
      """
    ]
    game
  end

  def display(game = %{ game_state: :lost, tally: tally }) do
    IO.puts [
      """
      You lost.
      Guessed until now: #{Enum.join(tally.letters, " ")}
      The word was #{tally.solution}
      """
    ]
    game
  end

  def display(game = %{ tally: tally }) do
    IO.puts [
      """
      Word so far: #{Enum.join(tally.letters, " ")}
      Already used: #{Enum.join(tally.used, " ")}
      Guesses left: #{tally.turns_left}
      """
    ]
    game
  end

end
