class Ui::Chat::Component < ApplicationComponent
  def initialize(stream: nil, **options)
    @stream = stream
    @options = options
  end

  erb_template <<~ERB
    <%= content_tag :div, class: classes, **attrs do %>
      <% if @stream %><%= helpers.turbo_stream_from(*Array(@stream)) %><% end %>
      <%= content %>
    <% end %>
  ERB

  private

  def attrs
    data_attributes = ({ controller: "chat" }).deep_merge(@options.fetch(:data, {}))
    @options.merge(data: data_attributes)
  end

  def classes
    class_names(
      "chat",
      @options.delete(:class)
    )
  end
end
