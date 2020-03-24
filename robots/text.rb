module Text
  def search(input)
    client = Algorithmia.client('sim8l5fOWEeOl92wBRqN6stmN3p1')
    algo = client.algo('web/WikipediaParser/0.1.2')
    algo.pipe(input).result
  end
end
