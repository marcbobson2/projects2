
class Robot
  ORIENTATION = [:north, :east, :south, :west]

  attr_accessor :current_orientation, :x, :y

  def orient(current_orientation)
    raise ArgumentError, "Invalid Direction" if !ORIENTATION.include?(current_orientation)
    @current_orientation = current_orientation
  end

  def turn_right
    @current_orientation = ORIENTATION[ORIENTATION.find_index(@current_orientation) + 1] || ORIENTATION[0]
  end

  def turn_left
    @current_orientation = ORIENTATION[ORIENTATION.find_index(@current_orientation) - 1] \
                        || ORIENTATION[ORIENTATION.index(ORIENTATION.last)]
  end

  def at(x,y)
    @x, @y = x, y
  end

  def coordinates
    [@x, @y]
  end

  def bearing
    @current_orientation
  end

  def advance
    case @current_orientation
    when :north then @y += 1
    when :south then @y -= 1
    when :east then @x += 1
    when :west then @x -= 1
    end
  end

end

class Simulator

  ACTIONS = { "L": :turn_left, "R": :turn_right, "A": :advance }
  
  def instructions(instruction_set)
    instruction_set.upcase!
    raise ArgumentError, "Invalid instruction set" if instruction_set.match(/[^#{ACTIONS.keys.join}]/)
    instruction_set.split("").map { |element| ACTIONS[element.to_sym] }
  end

  def place(robot_obj, robot_hash)
    robot_obj.x = robot_hash[:x]
    robot_obj.y = robot_hash[:y]
    robot_obj.current_orientation = robot_hash[:direction]
  end

  def evaluate(robot_obj, instruction_set)
      instructions(instruction_set).each { |instruction| robot_obj.send(instruction) }
  end
end

robot = Robot.new


sim = Simulator.new
sim.place(robot, x: -2, y: 1, direction: :east)
sim.evaluate(robot, "L")

