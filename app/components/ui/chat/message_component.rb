class Ui::Chat::MessageComponent < ApplicationComponent
  POSITIONS = %i[start end]
  DEFAULT_POSITION = :start

  def initialize(position: DEFAULT_POSITION, **options)
    @position = POSITIONS.include?(position) ? position : DEFAULT_POSITION
    @options = options
  end

  def call
    content_tag :div, content, class: classes, **@options
  end

  private

  def classes
    class_names(
      "chat__message",
      "chat__message--#{@position}",
      @options.delete(:class)
    )
  end
end
