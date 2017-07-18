class Toyrobot
  # TODO: we need make it better
  PLACE = 'place'.freeze
  MOVE = 'move'.freeze
  LEFT = 'left'.freeze
  RIGHT = 'right'.freeze
  REPORT = 'report'.freeze
  ONEWORD_COMMANDS = [MOVE, LEFT, RIGHT, REPORT].freeze
  NORTH = 'north'.freeze
  SOUTH = 'south'.freeze
  EAST = 'east'.freeze
  WEST = 'west'.freeze
  DIRECTIONS = [NORTH, EAST, SOUTH, WEST].freeze
  INVALID_COMMAND_MESSAGE = 'YOU ENTERED AN INVALID COMMAND'.freeze
  OUT_OF_TABLE_MESSAGE = 'I DO NOT WANT TO FALL ON THE FLOOR'.freeze
  ONLY_ONE_ROBOT_MESSAGE = 'HEY ITS TABLE ONLY FOR ME'.freeze
  PLACE_ME_MESSAGE = 'PLACE ME FIRST'.freeze
  NOTHING_TO_REPORT_MESSAGE = 'NOTHING TO REPORT'.freeze
  Position = Struct.new(:x, :y)

  attr_reader :command, :field_size

  def initialize(field_size = 5)
    @position = nil
    @direction = nil
    @field_size = field_size - 1
  end

  def simulate
    loop do
      @command = gets.chomp.downcase
      break if @command == 'exit'
      prepare_command!
      next if @command.empty? || invalid_command?

      send(@command.first.to_sym)
    end
  end

  private

  def prepare_command!
    @command = @command.split(/\s|,/).delete_if(&:empty?)
  end

  def invalid_command?
    return false if place_command? || oneword_command?

    puts INVALID_COMMAND_MESSAGE
    true
  end

  def place
    return(puts OUT_OF_TABLE_MESSAGE) unless place_on_table?
    return(puts ONLY_ONE_ROBOT_MESSAGE) unless @position.nil?

    @position = Position.new(command[1].to_i, command[2].to_i)
    @direction = command[3]
  end

  def place_on_table?
    x = command[1].to_i
    y = command[2].to_i
    valid_range.include?(x) && valid_range.include?(y)
  end

  def move
    case @direction
    when NORTH
      @position.y += 1 if valid_range.include?(@position.y + 1)
    when SOUTH
      @position.y -= 1 if valid_range.include?(@position.y - 1)
    when EAST
      @position.x += 1 if valid_range.include?(@position.x + 1)
    when WEST
      @position.x -= 1 if valid_range.include?(@position.x - 1)
    end
  end

  def left
    return(puts PLACE_ME_MESSAGE) if @direction.nil?
    index = DIRECTIONS.index(@direction)
    @direction = DIRECTIONS.rotate(-1)[index]
  end

  def right
    return(puts PLACE_ME_MESSAGE) if @direction.nil?
    index = DIRECTIONS.index(@direction)
    @direction = DIRECTIONS.rotate[index]
  end

  def report
    return(puts NOTHING_TO_REPORT_MESSAGE) if @position.nil? || @direction.nil?
    puts "#{@position.x}, #{@position.y}, #{@direction}"
  end

  def place_command?
    return false if PLACE != command.first ||
                    command.size != 4 ||
                    any_characters?(command[1]) ||
                    any_characters?(command[2]) ||
                    any_numbers?(command[3]) ||
                    invalid_direction?(command[3])
    true
  end

  def oneword_command?
    return false if !ONEWORD_COMMANDS.include?(command.first) ||
                    command.size != 1
    true
  end

  def any_numbers?(str)
    str.scan(/\d/).any?
  end

  def any_characters?(str)
    str.scan(/\D/).any?
  end

  def invalid_direction?(str)
    !DIRECTIONS.include?(str)
  end

  def valid_range
    0..field_size
  end
end
