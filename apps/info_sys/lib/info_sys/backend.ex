defmodule InfoSys.Backend do
  @callback name() :: String.t() #functions are defined along with types of argument and return values
  @callback compute(query :: String.t(), opts :: Keyword.t()) :: # .t() = typespec
    [%InfoSys.Result{}] # function return
end
