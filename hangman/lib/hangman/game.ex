defmodule Hangman.Game do
  alias __MODULE__

  defstruct [
    turns_left: 7,
    state: :initializing,
    letters: [],
    used: MapSet.new(),
  ]

  def init_game, do: init_game(Dictionary.random_word)
  def init_game(word) do
    %Game{
      letters: word |> String.codepoints
    }
  end

  def make_move(game = %{state: state }, _guess) when state in [:won, :lost] do
    return_with_tally(game)
  end
  def make_move(game, guess) do
    game = accept_move(game, guess, MapSet.member?(game.used, guess))
    return_with_tally(game)
  end

  def tally(game) do
    %{
      game_state: game.state,
      turns_left: game.turns_left,
      used: MapSet.to_list(game.used),
      solution: Enum.join(game.letters, ""),
      letters: game.letters |> reveal_guessed(game.used)
    }
  end

  # -------------------------------------------------------

  defp return_with_tally(game), do: {game, tally(game)}

  defp accept_move(game, _guess, _already_guessed = true) do
    Map.put(game, :state, :already_used)
  end

  defp accept_move(game, guess, _already_guessed) do
    result = Enum.member?(game.letters, guess)
    Map.put(game, :used, MapSet.put(game.used, guess))
    |> score_guess(result)
  end

  defp reveal_guessed(letters, used) do
    Enum.map(letters, &(reveal_letter(&1, MapSet.member?(used, &1))))
  end

  defp reveal_letter(letter, _in_word = true), do: letter
  defp reveal_letter(_letter, _not_in_word), do: "_"

  defp score_guess(game, _good_guess = true) do
    new_state = MapSet.new(game.letters)
    |> MapSet.subset?(game.used)
    |> maybe_won

    Map.put(game, :state, new_state)
  end

  defp score_guess(game = %{ turns_left: 1 }, _not_good_guess) do
    Map.put(game, :state, :lost)
  end
  defp score_guess(game = %{ turns_left: turns_left }, _not_good_guess) do
    %{ game |
      turns_left: turns_left-1,
      state: :bad_guess
    }
  end

  defp maybe_won(true), do: :won
  defp maybe_won(_), do: :good_guess
end

