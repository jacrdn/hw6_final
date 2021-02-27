defmodule Bulls.Game do
  # This module doesn't do stuff,
  # it computes stuff.

  def new do
    %{
      secret: random_secret(),

      name: "",

      lastGuess1: [],
      bulls1: 0,
      cows1: 0,

      lastGuess2: [],
      bulls2: 0,
      cows2: 0,

      lastGuess3: [],
      bulls3: 0,
      cows3: 0,

      lastGuess4: [],
      bulls4: 0,
      cows4: 0,
    }
  end

  def guess(st, gs) do
    cond do
      (valid(Enum.at(gs, 1)) and Enum.at(gs, 0) == "1") -> # convert to a cond branch
      %{
        st | lastGuess1: Enum.at(gs, 1),
        bulls1: getBulls(Enum.at(gs, 1), st.secret),
        cows1: getCows(Enum.at(gs, 1), st.secret),

        bulls2: st.bulls2,
        cows2: st.cows2,
        lastGuess2: st.lastGuess2,

        bulls3: st.bulls3,
        cows3: st.cows3,
        lastGuess3: st.lastGuess3,

        bulls4: st.bulls4,
        cows4: st.cows4,
        lastGuess4: st.lastGuess4,

        name: st.name,

        secret: st.secret,
      }
      (valid(Enum.at(gs, 1)) and Enum.at(gs, 0) == "2") -> # convert to a cond branch
      %{
        st | lastGuess2: Enum.at(gs, 1),
        bulls2: getBulls(Enum.at(gs, 1), st.secret),
        cows2: getCows(Enum.at(gs, 1), st.secret),

        bulls1: st.bulls1,
        cows1: st.cows1,
        lastGuess1: st.lastGuess1,

        bulls3: st.bulls3,
        cows3: st.cows3,
        lastGuess3: st.lastGuess3,

        bulls4: st.bulls4,
        cows4: st.cows4,
        lastGuess4: st.lastGuess4,

        name: st.name,
        secret: st.secret,
      }
      (valid(Enum.at(gs, 1)) and Enum.at(gs, 0) == "3") -> # convert to a cond branch
      %{
        st | lastGuess3: Enum.at(gs, 1),
        bulls3: getBulls(Enum.at(gs, 1), st.secret),
        cows3: getCows(Enum.at(gs, 1), st.secret),

        bulls2: st.bulls2,
        cows2: st.cows2,
        lastGuess2: st.lastGuess2,

        bulls1: st.bulls1,
        cows1: st.cows1,
        lastGuess1: st.lastGuess1,

        bulls4: st.bulls4,
        cows4: st.cows4,
        lastGuess4: st.lastGuess4,

        name: st.name,
        secret: st.secret,
      }
      (valid(Enum.at(gs, 1)) and Enum.at(gs, 0) == "4") -> # convert to a cond branch
      %{
        st | lastGuess4: Enum.at(gs, 1),
        bulls4: getBulls(Enum.at(gs, 1), st.secret),
        cows4: getCows(Enum.at(gs, 1), st.secret),

        bulls2: st.bulls2,
        cows2: st.cows2,
        lastGuess2: st.lastGuess2,

        bulls3: st.bulls3,
        cows3: st.cows3,
        lastGuess3: st.lastGuess3,

        bulls1: st.bulls1,
        cows1: st.cows1,
        lastGuess1: st.lastGuess1,

        name: st.name,
        secret: st.secret,
      }
    true ->
      %{
        lastGuess1: st.lastGuess1,
        bulls1: st.bulls1,
        cows1: st.cows1,

        bulls2: st.bulls2,
        cows2: st.cows2,
        lastGuess2: st.lastGuess2,

        bulls3: st.bulls3,
        cows3: st.cows3,
        lastGuess3: st.lastGuess3,

        bulls4: st.bulls4,
        cows4: st.cows4,
        lastGuess4: st.lastGuess4,

        name: st.name,
        secret: st.secret,
    }
    end
  end

  def indexOf(l, el) do
    tls = Enum.with_index(l)
    mp = Enum.map(tls, fn m -> Tuple.to_list(m) end)
    fl = Enum.filter(mp, fn e -> (Enum.at(e, 0) == el) end)
    Enum.at(Enum.at(fl, 0), 1)
  end


  def getBulls(g, sc) do
    ge = Enum.filter(String.split(g,""), fn x -> x != "" end)
    se = Enum.filter(String.split(sc,""), fn x -> x != "" end)
    zp = Enum.zip(ge, se)
    flt = Enum.filter(zp, fn x -> Enum.at(Tuple.to_list(x), 0) == Enum.at(Tuple.to_list(x), 1) end)
    Enum.count(flt)
  end

  def getCows(g, sc) do
    ge = Enum.filter(String.split(g,""), fn x -> x != "" end)
    se = Enum.filter(String.split(sc,""), fn x -> x != "" end)
    Enum.count(Enum.filter(ge, fn el -> Enum.member?(se, el) end)) - getBulls(g, sc)
  end

  def valid(g) do
    l_g = String.split(g, "") |> Enum.filter(fn x -> x != "" end)
    set_g = MapSet.size(MapSet.new(l_g))
    String.length(g) == 4 and (4 === set_g)
  end

  def view(st, name) do
    # word = st.secret
    # |> String.graphemes
    # |> Enum.map(fn xx ->
    #   if MapSet.member?(st.guesses, xx) do
    #     xx
    #   else
    #     "_"
    #   end
    # end)
    # |> Enum.join("")

    # %{
    #   word: word,
    #   guesses: MapSet.to_list(st.guesses),
    #   name: name,
    # }

    %{

      secret: st.secret,

      bulls1: st.bulls1,
      cows1: st.cows1,
      lastGuess1: st.lastGuess1,

      bulls2: st.bulls2,
      cows2: st.cows2,
      lastGuess2: st.lastGuess2,

      bulls3: st.bulls3,
      cows3: st.cows3,
      lastGuess3: st.lastGuess3,

      bulls4: st.bulls4,
      cows4: st.cows4,
      lastGuess4: st.lastGuess4,

      name: name,

    }
  end

  def setUn(st, un) do

    %{

      secret: st.secret,

      bulls1: st.bulls1,
      cows1: st.cows1,
      lastGuess1: st.lastGuess1,

      bulls2: st.bulls2,
      cows2: st.cows2,
      lastGuess2: st.lastGuess2,

      bulls3: st.bulls3,
      cows3: st.cows3,
      lastGuess3: st.lastGuess3,

      bulls4: st.bulls4,
      cows4: st.cows4,
      lastGuess4: st.lastGuess4,

      name: st.name,

    }

  end

  def random_secret() do
      d_l = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
      d_s = Enum.shuffle(d_l)
      u1 = hd(d_s)
      u2 = hd(tl(d_s))
      u3 = hd(tl(tl(d_s)))
      u4 = hd(tl(tl(tl(d_s))))
      Integer.to_string(u1) <> Integer.to_string(u2) <> Integer.to_string(u3) <> Integer.to_string(u4)
  end
end
