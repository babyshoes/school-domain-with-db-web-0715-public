require 'pry'
class Student

  attr_accessor :id, :name, :tagline, :github, :twitter,
                :blog_url, :image_url, :biography

  def self.create_table
    create = <<-SQL
        CREATE TABLE students(
          id INTEGER PRIMARY KEY,
          name TEXT,
          tagline TEXT,
          github TEXT,
          twitter TEXT,
          blog_url TEXT,
          image_url TEXT,
          biography TEXT
        );
    SQL
    DB[:conn].execute(create)
  end

  def self.drop_table
    drop = <<-SQL
      DROP TABLE students;
    SQL
    DB[:conn].execute(drop)
  end

  def insert
    # insert = <<-SQL
    #   INSERT INTO students(
    #     name,
    #     tagline,
    #     github,
    #     twitter,
    #     blog_url,
    #     image_url,
    #     biography
    #   )
    #   VALUES(?, ?, ?, ?, ?, ?, ?);
    # SQL
    # DB[:conn].execute(insert, name: name, tagline, github, twitter,
    #                   blog_url, image_url, biography)
    insert = <<-SQL
      INSERT INTO students(
        name,
        tagline,
        github,
        twitter,
        blog_url,
        image_url,
        biography
      )
      VALUES(:name, :tagline, :github, :twitter, :blog_url, :image_url, :biography);
    SQL
    DB[:conn].execute(insert, name: name, tagline: tagline, github: github,
    twitter: twitter, blog_url: blog_url, image_url: image_url, biography: blog_url)


    self.id = DB[:conn].execute('SELECT last_insert_rowid()
                                FROM students;').flatten[0]
  end

  def self.new_from_db(row)
    attributes = ["id", "name", "tagline", "github", "twitter",
                  "blog_url", "image_url", "biography"]

    person = new
    i=0
    while i < attributes.length
      person.send("#{attributes[i]}=", row[i])
      i += 1
    end
    person
  end

  def self.find_by_name(name)
    find = <<-SQL
      SELECT * FROM students WHERE name = ?;
    SQL
    row = DB[:conn].execute(find, name).flatten
    new_from_db(row) unless row.empty?
  end

  def update
    update = <<-SQL
      UPDATE students
      SET name = ?,
          tagline = ?,
          github = ?,
          twitter = ?,
          blog_url = ?,
          image_url = ?,
          biography = ?
      WHERE id = ?;
    SQL
    DB[:conn].execute(update, name, tagline, github, twitter,
                      blog_url, image_url, biography, id)
  end

  def persisted?
    !!id
  end

  def save
    persisted? ? update : insert
  end

end
