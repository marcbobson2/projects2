
class Garden
  DEFAULT_STUDENTS = ["alice", "bob", "charlie", "david", "eve", "fred", "ginny", "harriet", "ileana", "joseph", "kincaid", "larry"]
  PLANT_MAP = {"V" => :violets, "R" => :radishes, "G" => :grass, "C" => :clover}

  def initialize(diagram, students=DEFAULT_STUDENTS)
    @diagram = diagram.split("\n")
    students.sort!.map! {|student| student.downcase}
    create_instance_vars(students) # dynamicaly creates instance variable for each student
    assign_plants_to_students(students)
  end

  private

  def assign_plants_to_students(students)
    students.each { |student| instance_variable_set("@#{student}", get_student_plants) }
  end


  def get_student_plants
    plant_string = @diagram[0].slice!(0,2) << @diagram[1].slice!(0,2)
    plant_string.split("").map { |plant| PLANT_MAP[plant] }
  end

  def create_instance_vars(students)
    students.each do |student|
      instance_variable_set("@#{student}", "")
      self.class.__send__(:attr_accessor, "#{student.to_sym}")
    end
  end

end

#garden= Garden.new("VCRRGVRG\nRVGCCGCV")
#p garden.alice
#p garden.bob
#p garden.charlie


