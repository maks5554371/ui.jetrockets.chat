class Ui::Chat::Component < ApplicationComponent
  def initialize(streams: [], **options)
    @streams = Array(streams)
    @options = options
  end

  erb_template <<~ERB
    <%= content_tag :div, class: classes, **attrs do %>
      <% if @streams.any? %><%= helpers.turbo_stream_from(*@streams) %><% end %>
      <%= content %>
    <% end %>
  ERB

  private

  def attrs
    @options.merge(data: data_attributes)
  end

  def data_attributes
    { controller: "chat" }.deep_merge(@options.fetch(:data, {}))
  end

  def classes
    class_names(
      "chat",
      @options.delete(:class)
    )
  end
end
