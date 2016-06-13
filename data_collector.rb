require 'gosu'

class DataCollector < Gosu::Window
  SCREEN_WIDTH = 1028
  SCREEN_HEIGHT = 720

  def initialize
    super(SCREEN_WIDTH, SCREEN_HEIGHT, false)

    @small_font = Gosu::Font.new(self, "Arial", 12)
    @large_font = Gosu::Font.new(self, "Arial", SCREEN_HEIGHT / 10)
    @state = :running
  end

  def button_down(key)
    case key
    when Gosu::KbEscape
      close
    # when Gosu::MsLeft
    #   if state == :running
    #     if within_field?(mouse_x, mouse_y)
    #       row, col = screen_coord_to_cell(mouse_x, mouse_y)
    #       field.clear(row, col)
    #
    #       if field.any_mines_detonated?
    #         @state = :lost
    #       elsif field.all_cells_cleared?
    #         @state = :cleared
    #       end
    #     end
    #   end
    # when Gosu::KbSpace
    #   if state != :running
    #     reset
    #   end
    end
  end

  def draw
    draw_rect(0, 0, screen_width, screen_height, Gosu::Color::GRAY)
    draw_text(screen_width / 2, 10, "Data Collector", @large_font, Gosu::Color::RED)
    # draw_rect(start_x, start_y, field_width, field_height, Gosu::Color::BLACK)

    dark_gray = Gosu::Color.new(50, 50, 50)
    gray = Gosu::Color.new(127, 127, 127)
    light_gray = Gosu::Color.new(200, 200, 200)
    #
    # (0...field.row_count).each do |row|
    #   (0...field.column_count).each do |col|
    #     x = start_x + (col * cell_size)
    #     y = start_y + (row * cell_size)
    #
    #     adjacent_mines = 0
    #
    #     if !field.cell_cleared?(row, col)
    #       color = gray
    #     elsif field.contains_mine?(row, col)
    #       color = Gosu::Color::RED
    #     else
    #       adjacent_mines = field.adjacent_mines(row, col)
    #       color = light_gray
    #     end
    #
    #     draw_rect(x, y, cell_size, cell_size, dark_gray)
    #     draw_rect(x + 2, y + 2, cell_size - 4, cell_size - 4, color)
    #
    #     if adjacent_mines > 0
    #       text_x = x + (cell_size - mine_font.text_width(adjacent_mines)) / 2
    #       text_y = y + (cell_size - mine_font.height) / 2
    #
    #       draw_text(text_x, text_y, adjacent_mines, mine_font)
    #     end
    #   end
    # end
  end

  def draw_text(x, y, text, font, color)
    font.draw(text, x, y, 3, 1, 1, color)
  end

  def draw_rect(x, y, width, height, color)
    draw_quad(x, y, color,
      x + width, y, color,
      x + width, y + height, color,
      x, y + height, color)
  end

  def screen_width
    SCREEN_WIDTH
  end

  def screen_height
    SCREEN_HEIGHT
  end
end
