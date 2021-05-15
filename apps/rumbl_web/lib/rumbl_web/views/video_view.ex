defmodule RumblWeb.VideoView do
  use RumblWeb, :view
  # views are just modules with pure functions.
  def category_select_options(categories) do
    for category <- categories, do: {category.name, category.id}
  end
end
