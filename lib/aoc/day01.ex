defmodule Aoc.Day01 do
  @moduledoc false

  import Aoc.Utils

  @spec run(1 | 2) :: number
  def run(1), do: solve1(get_input(1))
  def run(2), do: solve2(get_input(1))

  @spec solve1(binary) :: number
  def solve1(input) do
    String.split(input, ", ", trim: true)
    |> Enum.reduce({{0, 0}, :north}, fn e, acc ->
      turn = String.first(e)
      blocks = String.to_integer(String.slice(e, 1..10))

      case {turn, acc} do
        {"R", {{x, y}, :north}} -> {{x + blocks, y}, :east}
        {"R", {{x, y}, :east}} -> {{x, y - blocks}, :south}
        {"R", {{x, y}, :south}} -> {{x - blocks, y}, :west}
        {"R", {{x, y}, :west}} -> {{x, y + blocks}, :north}
        {"L", {{x, y}, :north}} -> {{x - blocks, y}, :west}
        {"L", {{x, y}, :west}} -> {{x, y - blocks}, :south}
        {"L", {{x, y}, :south}} -> {{x + blocks, y}, :east}
        {"L", {{x, y}, :east}} -> {{x, y + blocks}, :north}
        _ -> acc
      end
    end)
    |> (fn {{x, y}, _} -> abs(x) + abs(y) end).()
  end

  @spec solve2(binary) :: number
  def solve2(input) do
    {path, _} =
      String.split(input, ", ", trim: true)
      |> Enum.map_reduce({{0, 0}, :north}, fn e, acc ->
        # This time we preserve the streches of path from starting location to
        # the ending one, in order to find where our path intersects itself
        # at first (eg. the first location visited twice).

        turn = String.first(e)
        blocks = String.to_integer(String.slice(e, 1..10))

        case {turn, acc} do
          {"R", {{x, y}, :north}} ->
            strech = for x <- (x + 1)..(x + blocks), do: {x, y}
            {strech, {List.last(strech), :east}}

          {"R", {{x, y}, :east}} ->
            strech = for y <- (y - 1)..(y - blocks), do: {x, y}
            {strech, {List.last(strech), :south}}

          {"R", {{x, y}, :south}} ->
            strech = for x <- (x - 1)..(x - blocks), do: {x, y}
            {strech, {List.last(strech), :west}}

          {"R", {{x, y}, :west}} ->
            strech = for y <- (y + 1)..(y + blocks), do: {x, y}
            {strech, {List.last(strech), :north}}

          {"L", {{x, y}, :north}} ->
            strech = for x <- (x - 1)..(x - blocks), do: {x, y}
            {strech, {List.last(strech), :west}}

          {"L", {{x, y}, :west}} ->
            strech = for y <- (y - 1)..(y - blocks), do: {x, y}
            {strech, {List.last(strech), :south}}

          {"L", {{x, y}, :south}} ->
            strech = for x <- (x + 1)..(x + blocks), do: {x, y}
            {strech, {List.last(strech), :east}}

          {"L", {{x, y}, :east}} ->
            strech = for y <- (y + 1)..(y + blocks), do: {x, y}
            {strech, {List.last(strech), :north}}

          _ ->
            {acc, acc}
        end
      end)

    path
    |> List.flatten()
    |> fst_visited_twice([])
    |> (fn {x, y} -> abs(x) + abs(y) end).()
  end

  defp fst_visited_twice([], _), do: nil

  defp fst_visited_twice([pos | to_visit], visited) do
    if Enum.member?(visited, pos) do
      pos
    else
      fst_visited_twice(to_visit, [pos | visited])
    end
  end
end
