defmodule RpMobileWeb.ErrorHelpers do

  def translate_error({msg, opts}) do
    if count = opts[:count] do
      Gettext.dngettext(RpMobileWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(RpMobileWeb.Gettext, "errors", msg, opts)
    end
  end
end
