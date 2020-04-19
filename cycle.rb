
class Cycle

  attr_reader :name, :chores, :people

  def initialize(name = "", chores = [], people = [])
    self.name = name
    self.chores = chores
    self.people = people
  end

  def name=(a_name)
    (a_name == "")? raise("Name can't be blank!"): @name = a_name
  end

  def chores=(some_chores)
    (some_chores.class != Array)? raise("Chores must be an array!"): @chores = some_chores
  end

  def people=(some_people)
    (some_people.class != Array)? raise("People must be an array!"): @people = some_people
  end

  def rotate(old_chores)
    old_chores.each do |chore|
      if self.chores.include?(chore) 
        
        index_of_previous_person = old_chores.index(chore)
        (index_of_previous_person == self.people.length - 1)? pointer = 0: pointer = index_of_previous_person + 1
        found = false

        until found do
          if self.people[pointer].chore == nil
            self.people[pointer].chore = chore
            found = true
          end
          pointer += 1
          pointer = 0 if pointer == self.people.length
        end
      end
    end
  end

  def to_s
    return("Name: #{self.name}, Chores: #{self.chores}, People: #{self.people}")
  end

end
