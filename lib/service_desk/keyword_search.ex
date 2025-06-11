defmodule ServiceDesk.KeywordSearch do
  def keywords?(text, keywords) do
    text
    |> search_keywords(keywords)
    |> Enum.find(fn
      %{match_type: match} when match in [:exact, :very_high] -> true
      _ -> false
    end)
  end
  
  def search_keywords(text, keywords, threshold \\ 0.8) do
    words = 
      text
      |> String.downcase()
      |> String.split(~r/\W+/, trim: true)
    
    keywords
    |> Enum.flat_map(fn keyword ->
      find_similar_words(words, String.downcase(keyword), threshold)
    end)
    |> Enum.sort_by(& &1.similarity, :desc)
  end

  defp find_similar_words(words, keyword, threshold) do
    words
    |> Enum.map(fn word ->
      similarity = jaro_winkler_similarity(word, keyword)
      %{
        word: word,
        keyword: keyword,
        similarity: similarity,
        match_type: get_match_type(similarity)
      }
    end)
    |> Enum.filter(& &1.similarity >= threshold)
  end

  def jaro_winkler_similarity(s1, s2) do
    if s1 == s2 do
      1.0
    else
      jaro_sim = jaro_similarity(s1, s2)
      prefix_length = common_prefix_length(s1, s2, 4)
      jaro_sim + (0.1 * prefix_length * (1 - jaro_sim))
    end
  end

  defp jaro_similarity(s1, s2) do
    len1 = String.length(s1)
    len2 = String.length(s2)
    
    if len1 == 0 and len2 == 0, do: 1.0
    if len1 == 0 or len2 == 0, do: 0.0
    
    match_window = max(div(max(len1, len2), 2) - 1, 0)
    s1_matches = find_matches(s1, s2, match_window)
    s2_matches = find_matches(s2, s1, match_window)
    matches = length(s1_matches)
    
    if matches == 0 do
      0.0
    else
      transpositions = count_transpositions(s1_matches, s2_matches)
      
      (matches / len1 + matches / len2 + (matches - transpositions) / matches) / 3
    end
  end

  defp find_matches(s1, s2, window) do
    s1_chars = String.graphemes(s1)
    s2_chars = String.graphemes(s2)
    
    s1_chars
    |> Enum.with_index()
    |> Enum.filter(fn {char, i} ->
      start_pos = max(0, i - window)
      end_pos = min(length(s2_chars) - 1, i + window)

      s2_chars
      |> Enum.slice(start_pos..end_pos//1)
      |> Enum.any?(& &1 == char)
    end)
    |> Enum.map(fn {char, _} -> char end)
  end

  defp count_transpositions(matches1, matches2) do
    matches1
    |> Enum.zip(matches2)
    |> Enum.count(fn {c1, c2} -> c1 != c2 end)
    |> div(2)
  end

  defp common_prefix_length(s1, s2, max_length) do
    s1_chars = String.graphemes(s1)
    s2_chars = String.graphemes(s2)
    
    s1_chars
    |> Enum.zip(s2_chars)
    |> Enum.take(max_length)
    |> Enum.take_while(fn {c1, c2} -> c1 == c2 end)
    |> length()
  end

  defp get_match_type(similarity) do
    cond do
      similarity == 1.0 -> :exact
      similarity >= 0.85 -> :very_high
      similarity >= 0.75 -> :high
      similarity >= 0.65
       -> :medium
      true -> :low
    end
  end
  
  def levenshtein_similarity(s1, s2) do
    distance = levenshtein_distance(s1, s2)
    max_len = max(String.length(s1), String.length(s2))
    
    if max_len == 0, do: 1.0, else: 1.0 - (distance / max_len)
  end

  def levenshtein_distance(s1, s2) do
    s1_chars = String.graphemes(s1)
    s2_chars = String.graphemes(s2)
    
    len1 = length(s1_chars)
    len2 = length(s2_chars)
    
    matrix = 
      for i <- 0..len1 do
        for j <- 0..len2 do
          cond do
            i == 0 -> j
            j == 0 -> i
            true -> 0
          end
        end
      end
    
    calculate_distance(s1_chars, s2_chars, matrix, len1, len2)
  end

  defp calculate_distance(s1_chars, s2_chars, matrix, len1, len2) do
    Enum.reduce(1..len1, matrix, fn i, acc_matrix ->
      Enum.reduce(1..len2, acc_matrix, fn j, inner_matrix ->
        cost = if Enum.at(s1_chars, i-1) == Enum.at(s2_chars, j-1), do: 0, else: 1
        
        deletion = get_matrix_value(inner_matrix, i-1, j) + 1
        insertion = get_matrix_value(inner_matrix, i, j-1) + 1
        substitution = get_matrix_value(inner_matrix, i-1, j-1) + cost
        
        min_cost = min(deletion, min(insertion, substitution))
        set_matrix_value(inner_matrix, i, j, min_cost)
      end)
    end)
    |> get_matrix_value(len1, len2)
  end

  defp get_matrix_value(matrix, i, j) do
    matrix |> Enum.at(i) |> Enum.at(j)
  end

  defp set_matrix_value(matrix, i, j, value) do
    List.update_at(matrix, i, fn row ->
      List.update_at(row, j, fn _ -> value end)
    end)
  end
end
