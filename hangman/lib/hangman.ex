defmodule Hangman do
  alias Hangman.Game

  defdelegate new_game, to: Game, as: :init_game
  defdelegate tally(game), to: Game
  defdelegate make_move(game, guess), to:  Game

end
