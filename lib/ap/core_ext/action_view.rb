module AwesomePrintActionView

  def ap_debug(object, options = {})
    formatted = h(object.ai(options))

    if not options[:plain]
      hash = {} # Build ANSI => HTML color map.
      [ :gray, :red, :green, :yellow, :blue, :purple, :cyan, :white ].each_with_index do |color, i|
        hash["\033[1;#{30+i}m"] = color
      end
      [ :black, :darkred, :darkgreen, :sienna, :navy, :darkmagenta, :darkcyan, :slategray ].each_with_index do |color, i|
        hash["\033[0;#{30+i}m"] = color
      end

      hash.each do |key, value|
        formatted.gsub!(key, %Q|<font color="#{value}">|)
      end
      formatted.gsub!("\033[0m", "</font>")
    end

    # tested and works in both rails 2 and rails 3
    return content_tag(:pre, formatted, :class => 'debug_dump')

    # use this block if that doesn't work out
    if Rails::VERSION::MAJOR >= 3
      return content_tag(:pre, formatted, :class => 'debug_dump')
    else
      return %Q|<pre class="debug_dump">#{formatted}</pre>|
    end
  end
  alias_method :ap, :ap_debug

end

ActionView::Base.send(:include, AwesomePrintActionView) if defined?(::ActionView)
