class TodoList
  attr_accessor :title

  def initialize(title)
    @title = title
    @todos = []
  end

  def add(todo)
    raise TypeError, "Can only add to-do objects" if todo.class != Todo
    @todos << todo
  end

  def item_at(idx)
    @todos.fetch(idx)
  end

  def size
    @todos.size
  end

  def first
    @todos.first
  end

  def last
    @todos.last
  end

  def mark_done_at(idx)
    item_at(idx).done!
  end

  def mark_undone_at(idx)
    item_at(idx).undone!
  end


  def shift
    @todos.shift
  end

  def pop
    @todos.pop
  end

  def remove_at(idx)
    @todos.delete(item_at(idx))
  end

  def to_s
    formatted_title = "----#{@title}----"
    [formatted_title, @todos]
  end

  def each
    idx = 0
    while idx <= @todos.size - 1 do 
      yield(@todos[idx])
      idx += 1
    end
  end

  def select
    results = []
    self.each do |todo|
      results << todo if yield(todo)
    end
    results
  end

  def find_by_title(title)
    self.select {|todo| todo.title == title}.first
    #self.each { |todo| return todo if todo.title == title }
  end

  def all_done
    select { |todo| todo.done? }
  end

  def all_done
    all_done = TodoList.new("All Done")
    self.select { |todo| todo.done? }.each {|todo| all_done.add(todo)}
    all_done
  end

  def all_not_done
    # returns new TodoList object containing only the not done items
    all_not_done = TodoList.new("All Not Done")
    self.select { |todo| !todo.done? }.each {|todo| all_not_done.add(todo)}
    all_not_done
  end

  def mark_done(title)
    find_by_title(title).done!
  end

  def mark_all_done
    self.each {|todo| todo.done!}
  end

  def mark_all_undone
    self.each {|todo| todo.undone!}
  end

end


class Todo
  DONE_MARKER = 'X'
  UNDONE_MARKER = ' '

  attr_accessor :title, :description, :done

  def initialize(title, description='')
    @title = title
    @description = description
    @done = false
  end

  def done!
    self.done = true
  end

  def done?
    done
  end

  def undone!
    self.done = false
  end

  def to_s
    "[#{done? ? DONE_MARKER : UNDONE_MARKER}] #{title}"
  end

end

# given
todo1 = Todo.new("Buy milk")
todo2 = Todo.new("Clean room")
todo3 = Todo.new("Go to gym")
list = TodoList.new("Today's Todos")

list.add(todo1)  # adds todo1 to end of list, returns list
list.add(todo2)  # adds todo2 to end of list, returns list
list.add(todo3)  # adds todo3 to end of list, returns list

todo1.done!

#p list.find_by_title("Clean room")

p list.all_done
#p list.all_not_done
#list.mark_done("Clean room") # takes a string as argument, and marks the first Todo object that matches the argument as done.

#list.mark_all_done
#p list.all_done
#list.mark_all_undone
#p list.all_not_done


