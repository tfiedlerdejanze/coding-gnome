defmodule GameTest do
  use ExUnit.Case

  alias Hangman.Game

  test "Game.new_game/0 returns Game struct" do
    game = Game.init_game()

    assert game.turns_left == 7
    assert game.state == :initializing
    assert length(game.letters) > 0
  end

  test "game.guess/2 does not change state for :won or :lost game_state" do
    for state <- [:won, :lost] do
      game = Game.init_game() |> Map.put(:state, state)
      assert {^game, _tally} = Game.make_move(game, "x")
    end
  end

  test "first occurence of letter is not already used" do
    game = Game.init_game()
    {game, _tally} = Game.make_move(game, "x")

    assert game.state != :already_used
    assert MapSet.size(game.used) == 1
  end

  test "second occurence of letter is already used" do
    game = Game.init_game()
    {game, _tally} = Game.make_move(game, "x")
    {game, _tally} = Game.make_move(game, "x")
    assert game.state == :already_used
    assert MapSet.size(game.used) == 1
  end

  test "a good guess is recognized" do
    game = Game.init_game("wibble")
    {game, _tally} = Game.make_move(game, "w")

    assert game.state == :good_guess
    assert game.turns_left == 7
  end

  test "guessing all letters sets game.state to :won" do
    game = Game.init_game("wibble")
    {game, _tally} = Game.make_move(game, "w")
    assert game.state == :good_guess
    assert game.turns_left == 7
    {game, _tally} = Game.make_move(game, "i")
    assert game.state == :good_guess
    assert game.turns_left == 7
    {game, _tally} = Game.make_move(game, "b")
    assert game.state == :good_guess
    assert game.turns_left == 7
    {game, _tally} = Game.make_move(game, "l")
    assert game.state == :good_guess
    assert game.turns_left == 7
    {game, _tally} = Game.make_move(game, "e")
    assert game.state == :won
    assert game.turns_left == 7
  end

  test "bad guess is recognized" do
    game = Game.init_game("wibble")

    {game, _tally} = Game.make_move(game, "x")
    assert game.state == :bad_guess
    assert game.turns_left == 6
  end

  test "lost game is recognized" do
    game = Game.init_game("w")

    {game, _tally} = Game.make_move(game, "a")
    {game, _tally} = Game.make_move(game, "b")
    {game, _tally} = Game.make_move(game, "c")
    {game, _tally} = Game.make_move(game, "d")
    {game, _tally} = Game.make_move(game, "e")
    {game, _tally} = Game.make_move(game, "f")
    {game, _tally} = Game.make_move(game, "g")
    assert game.state == :lost
  end
end
