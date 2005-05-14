# colouriser.rb: colourise text, based upon highlight tool
# author: Lawrence Oluyede <l.oluyede@gmail.com>

require 'session'

# customize PATH to make it work under another platform
PATH = "/usr/bin/highlight"
ARGS = "-f -l -t 8 -S %s"

module Colouriser
  def Colouriser.add_line_numbers(text)
    new_text = ""
    
    text.split("\n").each_with_index do |line, index|
      new_line = "%4d %s" % [index + 1, line]
      new_text = "%s%s\n" % [new_text, new_line]
    end
  
    return new_text
  end

  def Colouriser.wordwrap(str, len)
    str.gsub( /\n/, "\n\n" ).gsub( /(.{1,#{len}})(\s+|$)/, "\\1\n" )
  end
  
  def Colouriser.colourise(text, lang)
    text.map do |x|
      x.chomp
    end.join("\n")
    
    if lang == "txt"
      text = wordwrap(text, 79)
      text = add_line_numbers(text)
      return text
    end
    
    session = Session.new
    
    params = ARGS % lang
    cmd = "%s %s" % [PATH, params]

    session.execute cmd, :stdin => text
  end
end

